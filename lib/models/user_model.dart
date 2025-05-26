import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? bio;
  final String? location;
  final String? profileImageUrl;
  final String? photoUrl;
  final DateTime createdAt;
  final int booksShared;
  final int booksReceived;
  final double rating;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.bio,
    this.location,
    this.profileImageUrl,
    this.photoUrl,
    required this.createdAt,
    this.booksShared = 0,
    this.booksReceived = 0,
    this.rating = 0.0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'],
      location: data['location'],
      profileImageUrl: data['profileImageUrl'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      booksShared: data['booksShared'] ?? 0,
      booksReceived: data['booksReceived'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'bio': bio,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'booksShared': booksShared,
      'booksReceived': booksReceived,
      'rating': rating,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? bio,
    String? location,
    String? profileImageUrl,
    String? photoUrl,
    DateTime? createdAt,
    int? booksShared,
    int? booksReceived,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      booksShared: booksShared ?? this.booksShared,
      booksReceived: booksReceived ?? this.booksReceived,
      rating: rating ?? this.rating,
    );
  }
} 