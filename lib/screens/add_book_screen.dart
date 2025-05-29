import 'package:flutter/material.dart';
import 'package:swap_shelf/screens/components/add_book_image_picker.dart';
import 'package:swap_shelf/screens/components/add_book_form.dart';
import 'package:swap_shelf/screens/components/loading_overlay.dart';
import 'package:swap_shelf/screens/components/error_dialog.dart';
import 'package:swap_shelf/screens/components/confirmation_dialog.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  bool _isLoading = false;
  String? _imagePath;
  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Science Fiction',
    'Fantasy',
    'Romance',
    'Biography',
    'History',
    'Science',
    'Technology',
    'Self-Help',
    'Business',
    'Art',
    'Music',
    'Travel',
    'Cookbooks',
    'Poetry',
    'Drama',
    'Comics',
    'Children',
  ];

  final List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  void _handleImageSelected(String? imagePath) {
    setState(() {
      _imagePath = imagePath;
    });
  }

  Future<void> _handleSubmit(Map<String, dynamic> formData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement book submission logic
      await Future.delayed(const Duration(seconds: 2)); // Simulated API call

      if (!mounted) return;

      final shouldNavigate = await showDialog<bool>(
        context: context,
        builder: (context) => const ConfirmationDialog(
          title: 'Success',
          message: 'Book added successfully! Would you like to add another book?',
          confirmText: 'Add Another',
          cancelText: 'Go Back',
        ),
      );

      if (!mounted) return;

      if (shouldNavigate == true) {
        setState(() {
          _imagePath = null;
          _isLoading = false;
        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Error',
          message: 'Failed to add book. Please try again.',
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Adding book...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Book'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddBookImagePicker(
                imagePath: _imagePath,
                onImageSelected: _handleImageSelected,
              ),
              const SizedBox(height: 24),
              AddBookForm(
                onSubmit: _handleSubmit,
                isLoading: _isLoading,
                genres: _genres,
                availableColors: _availableColors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}