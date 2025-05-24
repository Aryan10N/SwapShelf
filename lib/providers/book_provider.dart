import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/firebase_service.dart';

class BookProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Book> _books = [];
  List<Book> _userBooks = [];
  bool _isLoading = false;
  String? _selectedCategory;
  bool _showOnlyAvailable = true;

  List<Book> get books => _books;
  List<Book> get userBooks => _userBooks;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;
  bool get showOnlyAvailable => _showOnlyAvailable;

  Future<void> loadBooks() async {
    try {
      _isLoading = true;
      notifyListeners();

      _books = await _firebaseService.getBooks(
        category: _selectedCategory,
        isAvailable: _showOnlyAvailable ? true : null,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserBooks(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userBooks = await _firebaseService.getUserBooks(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addBook(Book book) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.addBook(book);
      await loadBooks();
      await loadUserBooks(book.ownerId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.updateBook(bookId, data);
      await loadBooks();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId, String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.deleteBook(bookId);
      await loadBooks();
      await loadUserBooks(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Book> results = await _firebaseService.searchBooks(query);

      _isLoading = false;
      notifyListeners();
      return results;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    loadBooks();
  }

  void toggleShowOnlyAvailable() {
    _showOnlyAvailable = !_showOnlyAvailable;
    loadBooks();
  }
} 