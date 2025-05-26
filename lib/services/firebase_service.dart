import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/book_model.dart';
import '../models/user_model.dart';
import '../models/swap_request_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final TwitterLogin _twitterLogin = TwitterLogin(
    apiKey: 'YOUR_TWITTER_API_KEY',
    apiSecretKey: 'YOUR_TWITTER_API_SECRET',
    redirectURI: 'YOUR_TWITTER_REDIRECT_URI',
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Auth Methods
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'An account already exists with this email.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        case 'operation-not-allowed':
          throw 'Email/password accounts are not enabled.';
        case 'weak-password':
          throw 'The password is too weak.';
        default:
          throw 'An error occurred. Please try again.';
      }
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'wrong-password':
          throw 'Wrong password provided.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        case 'user-disabled':
          throw 'This user account has been disabled.';
        default:
          throw 'An error occurred. Please try again.';
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out: $e';
    }
  }

  // User Methods
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user profile: $e';
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Book Methods
  Future<void> addBook(Book book) async {
    try {
      await _firestore.collection('books').add(book.toMap());
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  Future<List<Book>> getBooks({String? category, bool? isAvailable}) async {
    try {
      Query query = _firestore.collection('books');
      
      if (category != null) {
        query = query.where('categories', arrayContains: category);
      }
      
      if (isAvailable != null) {
        query = query.where('isAvailable', isEqualTo: isAvailable);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Book(
          id: doc.id,
          title: data['title'] ?? '',
          author: data['author'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          ownerId: data['ownerId'] ?? '',
          ownerName: data['ownerName'] ?? '',
          isAvailable: data['isAvailable'] ?? true,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          categories: List<String>.from(data['categories'] ?? []),
          condition: data['condition'] ?? 'Good',
          isbn: data['isbn'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }

  Future<List<Book>> getUserBooks(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('books')
          .where('ownerId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get user books: $e');
    }
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('books').doc(bookId).update(data);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Search Methods
  Future<List<Book>> searchBooks(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('books')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  // Swap Request Methods
  Future<void> createSwapRequest({
    required String requesterId,
    required String bookId,
    required String ownerId,
    String? message,
    String? requesterBookId,
  }) async {
    try {
      final swapRequest = SwapRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        requesterId: requesterId,
        ownerId: ownerId,
        bookId: bookId,
        status: SwapRequestStatus.pending,
        createdAt: DateTime.now(),
        message: message,
        requesterBookId: requesterBookId,
      );

      await _firestore
          .collection('swap_requests')
          .doc(swapRequest.id)
          .set(swapRequest.toMap());

      // Create notification for the owner
      await _createNotification(
        userId: ownerId,
        title: 'New Swap Request',
        body: 'Someone wants to swap your book!',
        type: 'swap_request',
        data: {'swapRequestId': swapRequest.id},
      );
    } catch (e) {
      throw Exception('Failed to create swap request: $e');
    }
  }

  Future<SwapRequest?> getSwapRequest(String swapRequestId) async {
    try {
      final doc = await _firestore.collection('swap_requests').doc(swapRequestId).get();
      if (doc.exists) {
        return SwapRequest.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get swap request: $e');
    }
  }

  Future<List<SwapRequest>> getSwapRequests({
    String? userId,
    SwapRequestStatus? status,
  }) async {
    try {
      Query query = _firestore.collection('swap_requests');
      
      if (userId != null) {
        query = query.where('requesterId', isEqualTo: userId);
      }
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => SwapRequest.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get swap requests: $e');
    }
  }

  Future<void> updateSwapRequestStatus(
    String swapRequestId,
    SwapRequestStatus status,
  ) async {
    try {
      final swapRequest = await getSwapRequest(swapRequestId);
      if (swapRequest == null) {
        throw Exception('Swap request not found');
      }

      await _firestore.collection('swap_requests').doc(swapRequestId).update({
        'status': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for the requester
      String notificationTitle;
      String notificationBody;

      switch (status) {
        case SwapRequestStatus.accepted:
          notificationTitle = 'Swap Request Accepted';
          notificationBody = 'Your swap request has been accepted!';
          break;
        case SwapRequestStatus.rejected:
          notificationTitle = 'Swap Request Rejected';
          notificationBody = 'Your swap request has been rejected.';
          break;
        case SwapRequestStatus.completed:
          notificationTitle = 'Swap Completed';
          notificationBody = 'The book swap has been completed successfully!';
          break;
        default:
          return;
      }

      await _createNotification(
        userId: swapRequest.requesterId,
        title: notificationTitle,
        body: notificationBody,
        type: 'swap_request_update',
        data: {'swapRequestId': swapRequestId},
      );
    } catch (e) {
      throw Exception('Failed to update swap request status: $e');
    }
  }

  // Notification Methods
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();

      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw Exception('Failed to mark all notifications as read');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
      throw Exception('Failed to delete notification');
    }
  }

  Future<void> clearAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      for (var doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error clearing all notifications: $e');
      throw Exception('Failed to clear all notifications');
    }
  }

  Future<void> _createNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'data': data,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // Book Methods
  Future<Book?> getBook(String bookId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('books').doc(bookId).get();
      if (doc.exists) {
        return Book.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get book: $e');
    }
  }

  Future<List<SwapRequest>> getUserSwapRequests(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('swap_requests')
          .where('requesterId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => SwapRequest.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get user swap requests: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw 'An error occurred. Please try again.';
      }
    }
  }

  // Social Authentication Methods
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web platform
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile platform
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) throw 'Google sign in aborted';

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          final user = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? '',
            photoUrl: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
          );
          await createUserProfile(user);
        }
        return userCredential;
      }
    } catch (e) {
      print('Google Sign In Error: $e');
      throw 'Failed to sign in with Google: $e';
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        // Web platform
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.addScope('public_profile');
        return await _auth.signInWithPopup(facebookProvider);
      } else {
        // Mobile platform
        final LoginResult result = await _facebookAuth.login();
        if (result.status != LoginStatus.success) {
          throw 'Facebook sign in failed';
        }

        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          final user = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? '',
            photoUrl: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
          );
          await createUserProfile(user);
        }
        return userCredential;
      }
    } catch (e) {
      print('Facebook Sign In Error: $e');
      throw 'Failed to sign in with Facebook: $e';
    }
  }

  Future<UserCredential> signInWithTwitter() async {
    try {
      if (kIsWeb) {
        // Web platform
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();
        return await _auth.signInWithPopup(twitterProvider);
      } else {
        // Mobile platform
        final authResult = await _twitterLogin.login();
        if (authResult.status != TwitterLoginStatus.loggedIn) {
          throw 'Twitter sign in failed';
        }

        final OAuthCredential credential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          final user = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? '',
            photoUrl: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
          );
          await createUserProfile(user);
        }
        return userCredential;
      }
    } catch (e) {
      print('Twitter Sign In Error: $e');
      throw 'Failed to sign in with Twitter: $e';
    }
  }
} 