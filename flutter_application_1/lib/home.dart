import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];

  Future<void> fetchBooks() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/books'),
    );
    if (response.statusCode == 200) {
      setState(() {
        books = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book List')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (_, index) {
          final book = books[index];
          return ListTile(
            title: Text(book['title']),
            subtitle: Text('${book['author']} (${book['publishedyear']})'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookPage()),
          );
          fetchBooks();
        },
      ),
    );
  }
}