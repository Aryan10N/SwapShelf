import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String id;
  final String from;
  final String to;
  final String bookId;
  final int stars;
  final String comment;
  final DateTime timestamp;

  Rating({
    required this.id,
    required this.from,
    required this.to,
    required this.bookId,
    required this.stars,
    required this.comment,
    required this.timestamp,
  });

  factory Rating.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rating(
      id: doc.id,
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      bookId: data['bookId'] ?? '',
      stars: data['stars'] ?? 0,
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'bookId': bookId,
      'stars': stars,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  Rating copyWith({
    String? from,
    String? to,
    String? bookId,
    int? stars,
    String? comment,
    DateTime? timestamp,
  }) {
    return Rating(
      id: id,
      from: from ?? this.from,
      to: to ?? this.to,
      bookId: bookId ?? this.bookId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
    );
  }
} 