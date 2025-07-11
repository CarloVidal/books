import '../models/book.dart';
import 'api_service.dart';

class BookRepository {
  static final BookRepository _instance = BookRepository._internal();
  factory BookRepository() => _instance;
  BookRepository._internal();

  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all books from API
  Future<void> loadBooks() async {
    try {
      _isLoading = true;
      _error = null;
      _books = await ApiService.getBooks();
    } catch (e) {
      _error = e.toString();
      _books = [];
    } finally {
      _isLoading = false;
    }
  }

  // Add a new book
  Future<bool> addBook(Book book) async {
    try {
      final newBook = await ApiService.createBook(book);
      _books.add(newBook);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Update a book
  Future<bool> updateBook(String id, Book book) async {
    try {
      final updatedBook = await ApiService.updateBook(id, book);
      final index = _books.indexWhere((b) => b.id == id);
      if (index != -1) {
        _books[index] = updatedBook;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Delete a book
  Future<bool> deleteBook(String id) async {
    try {
      await ApiService.deleteBook(id);
      _books.removeWhere((book) => book.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      return await ApiService.searchBooks(query);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  // Get statistics
  Future<Map<String, dynamic>?> getStats() async {
    try {
      return await ApiService.getStats();
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  // Check API health
  Future<bool> checkApiHealth() async {
    return await ApiService.healthCheck();
  }

  // Clear error
  void clearError() {
    _error = null;
  }

  // Get book by ID
  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
} 