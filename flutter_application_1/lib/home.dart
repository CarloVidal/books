import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  Future<void> loadBooks() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getStringList('books') ?? [];
      List<Map<String, dynamic>> loadedBooks = booksJson
          .map((bookJson) => Map<String, dynamic>.from(jsonDecode(bookJson)))
          .toList();
      // If no books, add 4 sample books
      if (loadedBooks.isEmpty) {
        loadedBooks = [
          {
            'title': 'Kuko Ng Agila',
            'author': 'Harper Lee',
            'publishedYear': 1960,
            'createdAt': DateTime.now().toIso8601String(),
            'image': 'assets/demon1.jpg',
          },
          {
            'title': 'Deathly Hallows',
            'author': 'George Orwell',
            'publishedYear': 1949,
            'createdAt': DateTime.now().toIso8601String(),
            'image': 'assets/demon2.jpg',
          },
          {
            'title': 'Order of the Phoenix',
            'author': 'F. Scott Fitzgerald',
            'publishedYear': 1925,
            'createdAt': DateTime.now().toIso8601String(),
            'image': 'assets/demon3.jpg',
          },
          {
            'title': 'The Sorcerers Stone',
            'author': 'Jane Austen',
            'publishedYear': 1813,
            'createdAt': DateTime.now().toIso8601String(),
            'image': 'assets/demon4.jpg',
          },
        ];
        final sampleBooksJson = loadedBooks.map((book) => jsonEncode(book)).toList();
        await prefs.setStringList('books', sampleBooksJson);
      }
      setState(() {
        books = loadedBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load books:  e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = books.map((book) => jsonEncode(book)).toList();
      await prefs.setStringList('books', booksJson);
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to save books: ${e.toString()}';
      });
    }
  }

  Future<void> addBook(Map<String, dynamic> newBook) async {
    setState(() {
      books.insert(0, newBook);
    });
    await saveBooks();
  }

  Future<void> deleteBook(int index) async {
    setState(() {
      books.removeAt(index);
    });
    await saveBooks();
  }

  Future<void> editBook(int index, Map<String, dynamic> updatedBook) async {
    setState(() {
      books[index] = updatedBook;
    });
    await saveBooks();
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📖 My Book Library'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.transparent,
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookPage()),
          );
          if (result != null) {
            await addBook(result);
          }
        },
        icon: Icon(Icons.add),
        label: Text('Add Book'),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
            SizedBox(height: 16),
            Text(
              'Loading books...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadBooks,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No books yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first book to get started!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  color: Color(0xFFFFF8E1),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Container(
                    height: 110, // Fixed height for all cards
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Book Image
                        book['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  book['image'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD7B377).withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFFD7B377).withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.menu_book,
                                  color: Color(0xFFD7B377),
                                  size: 36,
                                ),
                              ),
                        SizedBox(width: 16),
                        // Book Info
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book['title'] ?? 'Untitled',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF3E2723), // Deep brown for visibility
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'by ${book['author'] ?? 'Unknown Author'}',
                                style: TextStyle(
                                  color: Color(0xFFD7B377),
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (book['publishedYear'] != null && book['publishedYear'] != 0) ...[
                                SizedBox(height: 2),
                                Text(
                                  'Published: ${book['publishedYear']}',
                                  style: TextStyle(
                                    color: Color(0xFFD7B377).withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Action buttons (edit/delete) can go here if needed
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit Icon
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Color(0xFF8B4513),
                                size: 20,
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddBookPage(
                                      initialBook: book,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  await editBook(index, result);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Book updated successfully'),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              tooltip: 'Edit Book',
                            ),
                            // Delete Icon
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Color(0xFFCD5C5C),
                                size: 20,
                              ),
                              onPressed: () async {
                                await _showDeleteConfirmation(context, index);
                              },
                              tooltip: 'Delete Book',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBookDetails(BuildContext context, Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            book['title'] ?? 'Untitled',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Author: ${book['author'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              if (book['publishedYear'] != null && book['publishedYear'] != 0)
                Text(
                  'Published: ${book['publishedYear']}',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Delete Book'),
          content: Text('Are you sure you want to delete "${books[index]['title']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteBook(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}