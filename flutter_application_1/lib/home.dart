import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'models/book.dart';
import 'services/book_repository.dart';
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookRepository _bookRepository = BookRepository();
  List<Book> _books = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadBooks();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadBooks() async {
    if (!_isConnected) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No internet connection. Please check your network.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await _bookRepository.loadBooks();
    
    setState(() {
      _books = _bookRepository.books;
      _isLoading = false;
      if (_bookRepository.error != null) {
        _hasError = true;
        _errorMessage = _bookRepository.error!;
      }
    });
  }

  Future<void> _addBook(Book book) async {
    setState(() {
      _isLoading = true;
    });

    final success = await _bookRepository.addBook(book);
    
    setState(() {
      _isLoading = false;
      if (success) {
        _books = _bookRepository.books;
        _hasError = false;
      } else {
        _hasError = true;
        _errorMessage = _bookRepository.error ?? 'Failed to add book';
      }
    });
  }

  Future<void> _deleteBook(String id) async {
    final success = await _bookRepository.deleteBook(id);
    
    if (success) {
      setState(() {
        _books = _bookRepository.books;
        _hasError = false;
      });
    } else {
      setState(() {
        _hasError = true;
        _errorMessage = _bookRepository.error ?? 'Failed to delete book';
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
        backgroundColor: Color(0xFF8B4513),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBooks,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          );
          if (result != null && result is Book) {
            await _addBook(result);
          }
        },
        backgroundColor: Color(0xFF8B4513),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF8B4513)),
            SizedBox(height: 16),
            Text('Loading books...'),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBooks,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No books found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first book by tapping the + button',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(book.image),
              radius: 25,
            ),
            title: Text(
              book.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Author: ${book.author}'),
                if (book.publishedYear != null)
                  Text('Year: ${book.publishedYear}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Book'),
                      content: Text('Are you sure you want to delete "${book.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteBook(book.id!);
                          },
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}