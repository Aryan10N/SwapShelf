import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final bool isAvailable;
  final String condition;
  final String location;
  final DateTime createdAt;
  final List<String> categories;
  final String isbn;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.isAvailable,
    required this.condition,
    required this.location,
    required this.createdAt,
    required this.categories,
    required this.isbn,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      condition: data['condition'] ?? '',
      location: data['location'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      categories: List<String>.from(data['categories'] ?? []),
      isbn: data['isbn'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'isAvailable': isAvailable,
      'condition': condition,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'categories': categories,
      'isbn': isbn,
    };
  }

  Book copyWith({
    String? title,
    String? author,
    String? description,
    String? category,
    String? imageUrl,
    String? ownerId,
    String? ownerName,
    bool? isAvailable,
    String? condition,
    String? location,
    DateTime? createdAt,
    List<String>? categories,
    String? isbn,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      isAvailable: isAvailable ?? this.isAvailable,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      categories: categories ?? this.categories,
      isbn: isbn ?? this.isbn,
    );
  }
} 