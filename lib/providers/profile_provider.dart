import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile(String userId) async {
    print('ProfileProvider: Loading profile for user $userId');
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Demo profile data
      _profile = UserProfile(
        id: userId,
        name: 'Sarah Johnson',
        email: 'sarah.j@example.com',
        phone: '+1 (555) 987-6543',
        address: '456 Reading Lane, Booktown, CA 90210',
        bio: 'Book enthusiast and avid reader. Love to share and discover new stories! Currently reading "The Midnight Library" by Matt Haig. Always looking for new book recommendations and swap opportunities.',
        profileImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
        booksShared: 15,
        booksReceived: 12,
        rating: 4.8,
        isVerified: true,
        socialLinks: [
          'twitter.com/sarahreads',
          'instagram.com/sarahsbookshelf',
          'goodreads.com/sarahj'
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastActive: DateTime.now(),
      );

      print('ProfileProvider: Demo profile created');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoading = false;
      notifyListeners();
      print('ProfileProvider: Profile loaded successfully');
    } catch (e) {
      print('ProfileProvider: Error loading profile - $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_profile != null) {
        _profile = _profile!.copyWith(
          profileImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      await _firebaseService.signOut();
      _profile = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 