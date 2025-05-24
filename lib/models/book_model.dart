import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final bool isAvailable;
  final DateTime createdAt;
  final List<String> categories;
  final String condition;
  final String isbn;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.isAvailable,
    required this.createdAt,
    required this.categories,
    required this.condition,
    required this.isbn,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
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
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'categories': categories,
      'condition': condition,
      'isbn': isbn,
    };
  }
} 