import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add a new book
  Future<String> addBook({
    required String title,
    required String author,
    required String description,
    required String category,
    required String condition,
    required String location,
    required File coverImage,
    required String ownerId,
  }) async {
    try {
      // Upload cover image
      final ref = _storage.ref().child('book_covers/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(coverImage);
      final imageUrl = await ref.getDownloadURL();

      // Create book document
      final docRef = await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
        'ownerId': ownerId,
        'available': true,
        'condition': condition,
        'location': location,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  // Get all available books
  Stream<List<Book>> getAvailableBooks() {
    return _firestore
        .collection('books')
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Get books by category
  Stream<List<Book>> getBooksByCategory(String category) {
    return _firestore
        .collection('books')
        .where('category', isEqualTo: category)
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Search books
  Stream<List<Book>> searchBooks(String query) {
    return _firestore
        .collection('books')
        .where('available', isEqualTo: true)
        .orderBy('title')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Get book by ID
  Future<Book> getBookById(String bookId) async {
    final doc = await _firestore.collection('books').doc(bookId).get();
    if (!doc.exists) throw Exception('Book not found');
    return Book.fromFirestore(doc);
  }

  // Update book availability
  Future<void> updateBookAvailability(String bookId, bool available) async {
    await _firestore.collection('books').doc(bookId).update({
      'available': available,
    });
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    try {
      // Get book data
      final doc = await _firestore.collection('books').doc(bookId).get();
      if (!doc.exists) throw Exception('Book not found');

      // Delete cover image
      final imageUrl = doc.data()?['imageUrl'];
      if (imageUrl != null) {
        final ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }

      // Delete book document
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Get user's listed books
  Stream<List<Book>> getUserBooks(String userId) {
    return _firestore
        .collection('books')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }
} 