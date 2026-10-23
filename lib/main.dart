import 'package:flutter/material.dart';
import 'package:aplikasi_apaweh/pages/home_page.dart';

void main() {
  runApp(const KopiKitaApp());
}

/// Root Widget aplikasi KopiKita
class KopiKitaApp extends StatelessWidget {
  const KopiKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KopiKita - Coffee & Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37), // Palet cokelat kopi
          primary: const Color(0xFF5D4037),
          secondary: const Color(0xFF8D6E63),
          surface: const Color(0xFFFBF8F5), // Background cream elegan
        ),
        scaffoldBackgroundColor: const Color(0xFFFBF8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBF8F5),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Color(0xFF3E2723)),
          titleTextStyle: TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}