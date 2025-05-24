import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../models/book_model.dart';
import '../models/user_model.dart';
import '../models/swap_request_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Auth Methods
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User Methods
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
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
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
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
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'read': true,
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
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
} 