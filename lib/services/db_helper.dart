import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'favorite_books.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            authors TEXT,
            thumbnail TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> get database async {
    return _database ??= await _initDb();
  }

  static Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert('favorites', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteBook(String title) async {
    final db = await database;
    await db.delete('favorites', where: 'title = ?', whereArgs: [title]);
  }

  static Future<List<Book>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  static Future<bool> isFavorited(String title) async {
    final db = await database;
    final maps =
        await db.query('favorites', where: 'title = ?', whereArgs: [title]);
    return maps.isNotEmpty;
  }
}
