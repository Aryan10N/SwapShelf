import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/request_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Create a new request
  Future<String> createRequest({
    required String bookId,
    required String requesterId,
    required String ownerId,
  }) async {
    try {
      final docRef = await _firestore.collection('requests').add({
        'bookId': bookId,
        'requesterId': requesterId,
        'ownerId': ownerId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'returnDate': null,
      });

      // Send notification to book owner
      await _sendRequestNotification(ownerId, 'New borrow request');

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  // Get requests for a user (as owner)
  Stream<List<Request>> getOwnerRequests(String userId) {
    return _firestore
        .collection('requests')
        .where('ownerId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList();
    });
  }

  // Get requests made by a user (as requester)
  Stream<List<Request>> getRequesterRequests(String userId) {
    return _firestore
        .collection('requests')
        .where('requesterId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Request.fromFirestore(doc)).toList();
    });
  }

  // Update request status
  Future<void> updateRequestStatus(
    String requestId,
    String status, {
    DateTime? returnDate,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status,
      };

      if (returnDate != null) {
        updates['returnDate'] = Timestamp.fromDate(returnDate);
      }

      await _firestore.collection('requests').doc(requestId).update(updates);

      // Get request details for notification
      final request = await _firestore.collection('requests').doc(requestId).get();
      final requesterId = request.data()?['requesterId'];

      // Send notification to requester
      if (requesterId != null) {
        await _sendRequestNotification(
          requesterId,
          'Your request has been $status',
        );
      }
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  // Delete request
  Future<void> deleteRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).delete();
  }

  // Send notification
  Future<void> _sendRequestNotification(String userId, String message) async {
    try {
      // Get user's FCM token
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final fcmToken = userDoc.data()?['fcmToken'];

      if (fcmToken != null) {
        // Send notification using Firebase Cloud Functions
        // Note: This requires a Cloud Function to be set up
        await _firestore.collection('notifications').add({
          'token': fcmToken,
          'title': 'SwapShelf',
          'body': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }
} 