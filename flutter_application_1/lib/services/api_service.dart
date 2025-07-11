import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.195.173:3000/api';
  
  // Get all books
  static Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> booksData = data['data'];
        return booksData.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create a new book
  static Future<Book> createBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Book.fromJson(data['data']);
      } else {
        throw Exception('Failed to create book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update a book
  static Future<Book> updateBook(String id, Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/books/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Book.fromJson(data['data']);
      } else {
        throw Exception('Failed to update book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete a book
  static Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/books/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Search books
  static Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> booksData = data['data'];
        return booksData.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get book statistics
  static Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/stats'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Health check
  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
} 