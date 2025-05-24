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

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.available,
  });
}