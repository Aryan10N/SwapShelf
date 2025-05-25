import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => true; // Always return true for demo

  AuthProvider() {
    print('AuthProvider: Initializing');
    // Create demo user model
    _userModel = UserModel(
      id: 'demo-user-123',
      email: 'sarah.j@example.com',
      name: 'Sarah Johnson',
      createdAt: DateTime.now(),
    );
    notifyListeners();
    print('AuthProvider: Demo user created');
  }

  String get currentUserId => 'demo-user-123'; // Always return demo user ID

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Test login functionality
      if (email == 'root' && password == 'root') {
        _userModel = UserModel(
          id: 'test-user-id',
          email: 'root@test.com',
          name: 'Test User',
          createdAt: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Regular Firebase authentication
      await _firebaseService.signInWithEmail(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _firebaseService.signUpWithEmail(email, password);
      
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await _firebaseService.createUserProfile(userModel);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      _user = null;
      _userModel = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.updateUserProfile(updatedUser.id, updatedUser.toMap());
      _userModel = updatedUser;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 