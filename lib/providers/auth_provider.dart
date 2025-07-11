import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  bool _isTestLogin = false; // Indicates test authentication using default credentials

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null || _isTestLogin;
  String? get error => _error;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = _firebaseService.currentUser;
    if (_user != null) {
      _userModel = await _firebaseService.getUserProfile(_user!.uid);
    }
    notifyListeners();
  }

  String get currentUserId => _user?.uid ?? (_isTestLogin ? 'root' : '');
  // --- Test Authentication Methods ---
  void signInTest() {
    // Mark as authenticated for testing without Firebase
    _isTestLogin = true;
    notifyListeners();
  }

  void signOutTest() {
    _isTestLogin = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _firebaseService.signInWithEmail(email, password);
      _user = userCredential.user;
      _userModel = await _firebaseService.getUserProfile(_user!.uid);
      
      notifyListeners();
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
      _user = userCredential.user;
      
      final userModel = UserModel(
        id: _user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await _firebaseService.createUserProfile(userModel);
      _userModel = userModel;
      
      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _firebaseService.resetPassword(email);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _firebaseService.signInWithGoogle();
      if (userCredential.user != null) {
        _user = userCredential.user;
        _userModel = await _firebaseService.getUserProfile(userCredential.user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _firebaseService.signInWithFacebook();
      if (userCredential.user != null) {
        _user = userCredential.user;
        _userModel = await _firebaseService.getUserProfile(userCredential.user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithTwitter() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _firebaseService.signInWithTwitter();
      if (userCredential.user != null) {
        _user = userCredential.user;
        _userModel = await _firebaseService.getUserProfile(userCredential.user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 