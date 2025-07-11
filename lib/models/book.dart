class Book {
  final String title;
  final String authors;
  final String thumbnail;
  final String? description;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnail,
    this.description,
  });

  // Convert from JSON (Google Books API)
  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'];
    return Book(
      title: info['title'] ?? 'No Title',
      authors: (info['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      thumbnail:
          info['imageLinks']?['thumbnail'] ?? 'https://via.placeholder.com/150',
      description: info['description'],
    );
  }

  // Convert to SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
      'description': description,
    };
  }

  // Convert from SQLite Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      authors: map['authors'],
      thumbnail: map['thumbnail'],
      description: map['description'],
    );
  }
}
