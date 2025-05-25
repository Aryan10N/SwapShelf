import 'package:flutter/material.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? bio;
  final String? profileImageUrl;
  final int booksShared;
  final int booksReceived;
  final double rating;
  final bool isVerified;
  final List<String> socialLinks;
  final DateTime createdAt;
  final DateTime lastActive;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.bio,
    this.profileImageUrl,
    this.booksShared = 0,
    this.booksReceived = 0,
    this.rating = 0.0,
    this.isVerified = false,
    this.socialLinks = const [],
    required this.createdAt,
    required this.lastActive,
  });

  // Calculate profile completion percentage
  double get profileCompletionPercentage {
    int totalFields = 6; // name, email, phone, address, bio, profileImage
    int completedFields = 2; // name and email are required

    if (phone != null && phone!.isNotEmpty) completedFields++;
    if (address != null && address!.isNotEmpty) completedFields++;
    if (bio != null && bio!.isNotEmpty) completedFields++;
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  // Get profile status based on completion
  String get profileStatus {
    if (profileCompletionPercentage >= 90) return 'Complete';
    if (profileCompletionPercentage >= 70) return 'Good';
    if (profileCompletionPercentage >= 50) return 'Fair';
    return 'Basic';
  }

  // Get profile status color
  Color get profileStatusColor {
    switch (profileStatus) {
      case 'Complete':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Copy with method for updating profile
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? bio,
    String? profileImageUrl,
    int? booksShared,
    int? booksReceived,
    double? rating,
    bool? isVerified,
    List<String>? socialLinks,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      booksShared: booksShared ?? this.booksShared,
      booksReceived: booksReceived ?? this.booksReceived,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      socialLinks: socialLinks ?? this.socialLinks,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
} 