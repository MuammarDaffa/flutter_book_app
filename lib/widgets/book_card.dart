import 'package:flutter/material.dart';
import '../models/book.dart';
import '../pages/detail_page.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(
          book.thumbnail,
          width: 50,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
        title: Text(book.title),
        subtitle: Text(book.authors),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(book: book),
            ),
          );
        },
      ),
    );
  }
}
