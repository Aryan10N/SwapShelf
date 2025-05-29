import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  auth.User? _user;
  AppUser? _appUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _appUser = await _authService.getUserProfile(user.uid);
      } else {
        _appUser = null;
      }
      notifyListeners();
    });
  }

  auth.User? get user => _user;
  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      _user = userCredential.user;
      if (_user != null) {
        _appUser = await _authService.getUserProfile(_user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _authService.signUpWithEmailAndPassword(
        email,
        password,
        name,
        null,
      );

      _user = userCredential.user;
      if (_user != null) {
        _appUser = await _authService.getUserProfile(_user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signOut();
      _user = null;
      _appUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.resetPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_user != null) {
        await _authService.updateUserProfile(
          name: name,
          profileImage: photoUrl != null ? File(photoUrl) : null,
        );
        _appUser = await _authService.getUserProfile(_user!.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 