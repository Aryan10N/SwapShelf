import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new rating
  Future<String> addRating({
    required String from,
    required String to,
    required String bookId,
    required int stars,
    required String comment,
  }) async {
    try {
      // Check if rating already exists
      final existingRating = await _firestore
          .collection('ratings')
          .where('from', isEqualTo: from)
          .where('to', isEqualTo: to)
          .where('bookId', isEqualTo: bookId)
          .get();

      if (existingRating.docs.isNotEmpty) {
        throw Exception('You have already rated this user for this book');
      }

      // Add rating
      final docRef = await _firestore.collection('ratings').add({
        'from': from,
        'to': to,
        'bookId': bookId,
        'stars': stars,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update user's average rating
      await _updateUserRating(to);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  // Get ratings for a user
  Stream<List<Rating>> getUserRatings(String userId) {
    return _firestore
        .collection('ratings')
        .where('to', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Rating.fromFirestore(doc)).toList();
    });
  }

  // Get ratings given by a user
  Stream<List<Rating>> getRatingsGiven(String userId) {
    return _firestore
        .collection('ratings')
        .where('from', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Rating.fromFirestore(doc)).toList();
    });
  }

  // Update user's average rating
  Future<void> _updateUserRating(String userId) async {
    try {
      // Get all ratings for the user
      final ratings = await _firestore
          .collection('ratings')
          .where('to', isEqualTo: userId)
          .get();

      if (ratings.docs.isEmpty) return;

      // Calculate average rating
      double totalStars = 0;
      for (var doc in ratings.docs) {
        totalStars += doc.data()['stars'] as int;
      }
      final averageRating = totalStars / ratings.docs.length;

      // Update user's rating
      await _firestore.collection('users').doc(userId).update({
        'rating': averageRating,
      });
    } catch (e) {
      print('Failed to update user rating: $e');
    }
  }

  // Delete rating
  Future<void> deleteRating(String ratingId) async {
    try {
      // Get rating details
      final rating = await _firestore.collection('ratings').doc(ratingId).get();
      if (!rating.exists) throw Exception('Rating not found');

      // Delete rating
      await _firestore.collection('ratings').doc(ratingId).delete();

      // Update user's average rating
      final to = rating.data()?['to'];
      if (to != null) {
        await _updateUserRating(to);
      }
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }

  // Get average rating for a user
  Future<double> getUserAverageRating(String userId) async {
    try {
      final ratings = await _firestore
          .collection('ratings')
          .where('to', isEqualTo: userId)
          .get();

      if (ratings.docs.isEmpty) return 0.0;

      double totalStars = 0;
      for (var doc in ratings.docs) {
        totalStars += doc.data()['stars'] as int;
      }

      return totalStars / ratings.docs.length;
    } catch (e) {
      print('Failed to get user average rating: $e');
      return 0.0;
    }
  }
} 