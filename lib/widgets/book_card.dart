import 'package:flutter/material.dart';
import '../models/book.dart';
import '../pages/detail_page.dart'; // ⬅️ import halaman detail

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ⬅️ Navigasi ke detail ketika buku diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(book: book),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.thumbnail.startsWith('http')
                  ? Image.network(
                      book.thumbnail,
                      height: 160,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      book.thumbnail,
                      height: 160,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              book.authors,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
