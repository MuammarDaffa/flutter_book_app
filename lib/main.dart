import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/home_page.dart';
import 'pages/favorite_page.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatefulWidget {
  const BookApp({super.key});

  @override
  State<BookApp> createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Buku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(), // <- Splash screen
        '/home': (_) => HomePage(toggleTheme: toggleTheme),
        '/favorites': (_) => const FavoritePage(),
      },
    );
  }
}
