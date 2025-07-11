import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> _books;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _books = ApiService.fetchBooks("flutter");
  }

  void _searchBooks() {
    setState(() {
      _books = ApiService.fetchBooks(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode), // bisa juga Icons.light_mode
            tooltip: 'Ganti Tema',
            onPressed: widget.toggleTheme, // panggil fungsi dari atas
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Lihat Favorit',
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari buku (misal: Flutter, Harry Potter)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchBooks,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _books,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Buku tidak ditemukan."));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return BookCard(book: snapshot.data![index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
