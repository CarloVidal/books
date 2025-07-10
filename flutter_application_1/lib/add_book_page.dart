import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedYearController =
      TextEditingController();

  Future<void> addBook() async {
    final res = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/books'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'author': _authorController.text,
        'publishedYear': int.tryParse(_publishedYearController.text) ?? 0,
      }),
    );

    if (res.statusCode == 201) {
      Navigator.pop(context); // go back to HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: _publishedYearController,
              decoration: InputDecoration(labelText: 'Published Year'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addBook, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}