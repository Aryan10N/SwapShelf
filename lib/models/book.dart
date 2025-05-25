// lib/models/book.dart
import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final Color color;
  final bool available;
  final String? isbn;
  final String? genre;
  final int condition;
  final double price;
  final String? location;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.available,
    this.isbn,
    this.genre,
    this.condition = 5,
    this.price = 0.0,
    this.location,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    Color? color,
    bool? available,
    String? isbn,
    String? genre,
    int? condition,
    double? price,
    String? location,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      available: available ?? this.available,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      location: location ?? this.location,
    );
  }
}