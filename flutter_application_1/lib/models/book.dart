class Book {
  final String? id;
  final String title;
  final String author;
  final int? publishedYear;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.publishedYear,
    this.image = 'assets/libro.jpg',
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      publishedYear: json['publishedYear'],
      image: json['image'] ?? 'assets/libro.jpg',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'publishedYear': publishedYear,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, publishedYear: $publishedYear)';
  }
} 