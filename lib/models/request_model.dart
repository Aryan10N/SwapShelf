import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String id;
  final String bookId;
  final String requesterId;
  final String ownerId;
  final String status;
  final DateTime timestamp;
  final DateTime? returnDate;

  Request({
    required this.id,
    required this.bookId,
    required this.requesterId,
    required this.ownerId,
    required this.status,
    required this.timestamp,
    this.returnDate,
  });

  factory Request.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Request(
      id: doc.id,
      bookId: data['bookId'] ?? '',
      requesterId: data['requesterId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      returnDate: data['returnDate'] != null
          ? (data['returnDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'requesterId': requesterId,
      'ownerId': ownerId,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'returnDate': returnDate != null ? Timestamp.fromDate(returnDate!) : null,
    };
  }

  Request copyWith({
    String? bookId,
    String? requesterId,
    String? ownerId,
    String? status,
    DateTime? timestamp,
    DateTime? returnDate,
  }) {
    return Request(
      id: id,
      bookId: bookId ?? this.bookId,
      requesterId: requesterId ?? this.requesterId,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      returnDate: returnDate ?? this.returnDate,
    );
  }
} 