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
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final userData = await _firebaseService.getUserProfile(_user!.uid);
      _userModel = userData;
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Test login functionality
      if (email == 'root' && password == 'root') {
        // Create a test user model
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