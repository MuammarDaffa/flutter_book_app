import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_helper.dart';

class DetailPage extends StatefulWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  void _checkFavorite() async {
    final result = await DBHelper.isFavorited(widget.book.title);
    setState(() {
      isFavorited = result;
    });
  }

  void _toggleFavorite() async {
    if (isFavorited) {
      await DBHelper.deleteBook(widget.book.title);
    } else {
      await DBHelper.insertBook(widget.book);
    }

    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.book.thumbnail.startsWith('http')
                  ? Image.network(
                      widget.book.thumbnail,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      widget.book.thumbnail,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Text(widget.book.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Penulis: ${widget.book.authors}'),
            const SizedBox(height: 16),
            Text(
              (widget.book.description != null &&
                      widget.book.description!.trim().isNotEmpty)
                  ? widget.book.description!
                  : 'Tidak ada deskripsi',
            ),
          ],
        ),
      ),
    );
  }
}
