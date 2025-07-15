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

  // ✅ Untuk parsing dari Google Books API
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      title: volumeInfo['title'] ?? 'No Title',
      authors: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      thumbnail: imageLinks['thumbnail'] ?? 'assets/images/default_cover.png',
      // fallback
      description: volumeInfo['description'] ?? '',
    );
  }

  // ✅ Untuk menyimpan ke database SQLite
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
      'description': description ?? '',
    };
  }

  // ✅ Untuk mengambil dari database SQLite
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      authors: map['authors'],
      thumbnail: map['thumbnail'],
      description: map['description'],
    );
  }
}
