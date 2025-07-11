import 'package:flutter/material.dart';
import 'dart:math';

class AddBookPage extends StatefulWidget {
  final Map<String, dynamic>? initialBook;
  AddBookPage({this.initialBook});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedYearController = TextEditingController();
  
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialBook != null) {
      _titleController.text = widget.initialBook!['title'] ?? '';
      _authorController.text = widget.initialBook!['author'] ?? '';
      final year = widget.initialBook!['publishedYear'];
      _publishedYearController.text = (year != null && year != 0) ? year.toString() : '';
    }
  }

  Future<void> addOrEditBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final sampleImages = [
      'assets/demon5.jpg',
      'assets/demon6.jpg',
      'assets/libro.jpg',
      'assets/libro.jpg',
    ];
    final random = Random();
    final randomImage = sampleImages[random.nextInt(sampleImages.length)];

    try {
      final bookData = {
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'publishedYear': int.tryParse(_publishedYearController.text) ?? 0,
        'createdAt': widget.initialBook?['createdAt'] ?? DateTime.now().toIso8601String(),
        'image': widget.initialBook?['image'] ?? randomImage,
      };
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context, bookData);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to save book: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publishedYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialBook != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '✏️ Edit Book' : '📖 Add New Book'),
        elevation: 0,
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24),
                    // Header
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            isEditing ? Icons.edit : Icons.menu_book,
                            size: 48,
                            color: Color(0xFFD7B377),
                          ),
                          SizedBox(height: 16),
                          Text(
                            isEditing ? 'Edit Book' : 'Add a New Book',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF3E2723),
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isEditing
                                ? 'Update the details below to edit your book'
                                : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFD7B377),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Form Fields
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Title Field
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Book Title',
                              prefixIcon: Icon(Icons.title, color: Color(0xFFD7B377)),
                              hintText: 'Enter the book title',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a book title';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Author Field
                          TextFormField(
                            controller: _authorController,
                            decoration: InputDecoration(
                              labelText: 'Author',
                              prefixIcon: Icon(Icons.person, color: Color(0xFFD7B377)),
                              hintText: 'Enter the author name',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an author name';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Published Year Field
                          TextFormField(
                            controller: _publishedYearController,
                            decoration: InputDecoration(
                              labelText: 'Published Year',
                              prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFD7B377)),
                              hintText: 'Enter the published year (optional)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final year = int.tryParse(value);
                                if (year == null) {
                                  return 'Please enter a valid year';
                                }
                                if (year < 1000 || year > DateTime.now().year + 1) {
                                  return 'Please enter a valid year';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Error Message
                    if (errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade600),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 24),
                    
                    // Submit Button
                    ElevatedButton(
                      onPressed: isLoading ? null : addOrEditBook,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(isEditing ? 'Saving...' : 'Adding Book...'),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isEditing ? Icons.save : Icons.add),
                                SizedBox(width: 8),
                                Text(
                                  isEditing ? 'Save Changes' : 'Add Book',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}