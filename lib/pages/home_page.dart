import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import '../pages/detail_page.dart'; // ⬅️  ini untuk navigasi

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
    _books = ApiService.fetchBooks("Harry Potter");
  }

  void _searchBooks() {
    setState(() {
      _books = ApiService.fetchBooks(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔍 Search bar + toggle tema
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _searchBooks(),
                      decoration: InputDecoration(
                        hintText: 'Search book here...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.dark_mode),
                    onPressed: widget.toggleTheme,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📸 Banner
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/upcoming1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Upcoming Book\n30+ new book coming...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              // 📚 Daftar Buku
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
                      final recommended = snapshot.data!.take(5).toList();
                      final trending = snapshot.data!.skip(5).toList();

                      return ListView(
                        children: [
                          _buildSectionTitle("Recommended for you"),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommended.length,
                              itemBuilder: (context, index) {
                                final book = recommended[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailPage(book: book),
                                      ),
                                    );
                                  },
                                  child: BookCard(book: book),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle("Trending Book"),
                          const SizedBox(height: 12),
                          Column(
                            children: trending.map((book) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailPage(book: book),
                                    ),
                                  );
                                },
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                leading: Image.network(book.thumbnail,
                                    width: 50, fit: BoxFit.cover),
                                title: Text(book.title),
                                subtitle: Text(book.authors),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("See more"),
        ),
      ],
    );
  }
}
