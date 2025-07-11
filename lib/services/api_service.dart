import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static Future<List<Book>> fetchBooks(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeQueryComponent(query)}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data buku');
    }
  }
}
