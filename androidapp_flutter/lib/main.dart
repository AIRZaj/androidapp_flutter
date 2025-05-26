import 'package:flutter/material.dart';
import 'PeopleList.dart';
import 'authors_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Książka adresowa UAM Fizyka',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366), // UAM niebieski
          primary: const Color(0xFF003366), // UAM niebieski
          secondary: const Color(0xFF0066CC), // UAM jasny niebieski
          tertiary: const Color(0xFFCC0000), // UAM czerwony
          background: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF003366),
          onSurface: const Color(0xFF003366),
          error: const Color(0xFFCC0000), // UAM czerwony
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366), // UAM niebieski
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003366), // UAM niebieski
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF003366), // UAM niebieski
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF003366), // UAM niebieski
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF003366), // UAM niebieski
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF003366), // UAM niebieski
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF003366), // UAM niebieski
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF003366), // UAM niebieski
          thickness: 1,
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF003366), // UAM niebieski
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Książka adresowa UAM Fizyka'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthorsPage()),
              );
            },
          ),
        ],
      ),
      body: const PostListScreen(),
    );
  }
}
