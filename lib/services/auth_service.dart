import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user
  auth.User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<auth.UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<auth.UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    File? profileImage,
  ) async {
    try {
      // Create user
      final auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload profile image if provided
      String? profileImageUrl;
      if (profileImage != null) {
        final ref = _storage.ref().child('profile_images/${result.user!.uid}');
        await ref.putFile(profileImage);
        profileImageUrl = await ref.getDownloadURL();
      }

      // Create user profile in Firestore
      await _createUserProfile(
        result.user!.uid,
        name,
        email,
        profileImageUrl,
      );

      // Send email verification
      await result.user!.sendEmailVerification();

      return result;
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile(
    String userId,
    String name,
    String email,
    String? profileImageUrl,
  ) async {
    final userData = {
      'name': name,
      'email': email,
      'profileImage': profileImageUrl,
      'rating': 0.0,
      'joinDate': FieldValue.serverTimestamp(),
      'preferences': {
        'notifications': true,
        'emailNotifications': true,
      },
    };

    await _firestore.collection('users').doc(userId).set(userData);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    File? profileImage,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      String? profileImageUrl;
      if (profileImage != null) {
        final ref = _storage.ref().child('profile_images/${user.uid}');
        await ref.putFile(profileImage);
        profileImageUrl = await ref.getDownloadURL();
      }

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (profileImageUrl != null) updates['profileImage'] = profileImageUrl;

      await _firestore.collection('users').doc(user.uid).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'weak-password':
        return 'Password is too weak.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
} 