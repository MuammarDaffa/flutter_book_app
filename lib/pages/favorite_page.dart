import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_helper.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Book>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _favoriteBooks = DBHelper.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buku Favorit")),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));

          final books = snapshot.data ?? [];

          if (books.isEmpty)
            return const Center(child: Text("Tidak ada buku favorit."));

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: Image.network(book.thumbnail, width: 50),
                title: Text(book.title),
                subtitle: Text(book.authors),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(book: book)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
