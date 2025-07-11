import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('ProfileScreen: initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    print('ProfileScreen: _loadProfile called');
    try {
      final authProvider = context.read<AuthProvider>();
      print('ProfileScreen: Auth state - ${authProvider.isAuthenticated}');
      
      if (!authProvider.isAuthenticated) {
        print('ProfileScreen: User not authenticated, redirecting to welcome screen');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
        return;
      }

      final userId = authProvider.currentUserId;
      print('ProfileScreen: User ID - $userId');
      
      if (userId != null) {
        await context.read<ProfileProvider>().loadProfile(userId);
      } else {
        print('ProfileScreen: No user ID found');
      }
    } catch (e) {
      print('ProfileScreen: Error loading profile - $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await context.read<ProfileProvider>().updateProfileImage(_image!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        final profile = context.read<ProfileProvider>().profile;
        if (profile != null) {
          _nameController.text = profile.name;
          _phoneController.text = profile.phone ?? '';
          _addressController.text = profile.address ?? '';
          _bioController.text = profile.bio ?? '';
        }
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final profile = context.read<ProfileProvider>().profile;
        if (profile != null) {
          final updatedProfile = profile.copyWith(
            name: _nameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            bio: _bioController.text,
          );
          await context.read<ProfileProvider>().updateProfile(updatedProfile);
          setState(() => _isEditing = false);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Color(0xFF6C63FF),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.black87),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileProvider>().logout();
              context.read<AuthProvider>().signOutTest();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('ProfileScreen: Building widget');
    return Consumer2<ProfileProvider, AuthProvider>(
      builder: (context, profileProvider, authProvider, child) {
        print('ProfileScreen: Consumer builder called');
        print('ProfileScreen: Auth state - ${authProvider.isAuthenticated}');
        print('ProfileScreen: Loading state - ${profileProvider.isLoading}');
        print('ProfileScreen: Profile exists - ${profileProvider.profile != null}');

        if (!authProvider.isAuthenticated) {
          print('ProfileScreen: Not authenticated, showing loading');
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            ),
          );
        }

        final profile = profileProvider.profile;
        final isLoading = profileProvider.isLoading;
        final error = profileProvider.error;

        if (error != null) {
          print('ProfileScreen: Error state - $error');
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (isLoading) {
          print('ProfileScreen: Loading state');
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            ),
          );
        }

        if (profile == null) {
          print('ProfileScreen: No profile found');
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Profile not found',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          );
        }

        print('ProfileScreen: Building profile UI');
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.save : Icons.edit,
                  color: const Color(0xFF6C63FF),
                ),
                onPressed: _isEditing ? _saveProfile : _toggleEdit,
              ),
            ],
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(profile),
                  const SizedBox(height: 32),
                  _buildProfileStats(profile),
                  const SizedBox(height: 32),
                  _buildProfileInfo(profile),
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (profile.profileImageUrl != null
                        ? NetworkImage(profile.profileImageUrl!)
                        : null) as ImageProvider?,
                child: _image == null && profile.profileImageUrl == null
                    ? Text(
                        profile.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _pickImage,
            child: const Text(
              'Change Profile Picture',
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          if (profile.isVerified) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileStats(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Books Shared',
                profile.booksShared.toString(),
                Icons.share,
              ),
              _buildStatItem(
                'Books Received',
                profile.booksReceived.toString(),
                Icons.book,
              ),
              _buildStatItem(
                'Rating',
                profile.rating.toStringAsFixed(1),
                Icons.star,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: profile.profileCompletionPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(profile.profileStatusColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Profile ${profile.profileStatus} (${profile.profileCompletionPercentage.toStringAsFixed(0)}%)',
            style: TextStyle(
              color: profile.profileStatusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF6C63FF),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.save : Icons.edit,
                  color: const Color(0xFF6C63FF),
                ),
                onPressed: _isEditing ? _saveProfile : _toggleEdit,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEditableField(
            'Name',
            _nameController,
            profile.name,
            enabled: _isEditing,
            icon: Icons.person,
          ),
          _buildEditableField(
            'Email',
            TextEditingController(text: profile.email),
            profile.email,
            enabled: false,
            icon: Icons.email,
          ),
          _buildEditableField(
            'Phone',
            _phoneController,
            profile.phone ?? 'Not set',
            enabled: _isEditing,
            icon: Icons.phone,
          ),
          _buildEditableField(
            'Address',
            _addressController,
            profile.address ?? 'Not set',
            enabled: _isEditing,
            icon: Icons.location_on,
          ),
          _buildEditableField(
            'Bio',
            _bioController,
            profile.bio ?? 'Not set',
            enabled: _isEditing,
            maxLines: 3,
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    String value, {
    bool enabled = false,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          enabled
              ? TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black87),
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    hintText: 'Enter $label',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                )
              : Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }
} 