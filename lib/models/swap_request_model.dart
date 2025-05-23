import 'package:cloud_firestore/cloud_firestore.dart';

enum SwapRequestStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled
}

class SwapRequest {
  final String id;
  final String requesterId;
  final String ownerId;
  final String bookId;
  final SwapRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? message;
  final String? requesterBookId; // Optional book offered in return

  SwapRequest({
    required this.id,
    required this.requesterId,
    required this.ownerId,
    required this.bookId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.message,
    this.requesterBookId,
  });

  factory SwapRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SwapRequest(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      bookId: data['bookId'] ?? '',
      status: SwapRequestStatus.values.firstWhere(
        (e) => e.toString() == 'SwapRequestStatus.${data['status']}',
        orElse: () => SwapRequestStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      message: data['message'],
      requesterBookId: data['requesterBookId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requesterId': requesterId,
      'ownerId': ownerId,
      'bookId': bookId,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'message': message,
      'requesterBookId': requesterBookId,
    };
  }

  SwapRequest copyWith({
    String? id,
    String? requesterId,
    String? ownerId,
    String? bookId,
    SwapRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? message,
    String? requesterBookId,
  }) {
    return SwapRequest(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      ownerId: ownerId ?? this.ownerId,
      bookId: bookId ?? this.bookId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      message: message ?? this.message,
      requesterBookId: requesterBookId ?? this.requesterBookId,
    );
  }
} 