import 'news.dart';
import 'people_list.dart';
import 'map.dart';
import 'package:flutter/material.dart';
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
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
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
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Color(0xFF003366)), // UAM niebieski
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                WidgetStatePropertyAll(Color(0xFF003366)), // UAM niebieski
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
        menuTheme: const MenuThemeData(
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    PostListScreen(),
    MapScreen(),
    NewsScreen(),
    AuthorsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF003366), // UAM niebieski
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType
            .fixed, // Use fixed type for better performance
        elevation: 8, // Add elevation for better visual hierarchy
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Aktualności',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Authors',
          ),
        ],
      ),
    );
  }
}
