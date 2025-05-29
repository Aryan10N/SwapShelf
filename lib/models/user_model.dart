import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final double rating;
  final DateTime joinDate;
  final Map<String, dynamic> preferences;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.rating,
    required this.joinDate,
    required this.preferences,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      preferences: data['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'rating': rating,
      'joinDate': Timestamp.fromDate(joinDate),
      'preferences': preferences,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? profileImage,
    double? rating,
    DateTime? joinDate,
    Map<String, dynamic>? preferences,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      joinDate: joinDate ?? this.joinDate,
      preferences: preferences ?? this.preferences,
    );
  }
} 