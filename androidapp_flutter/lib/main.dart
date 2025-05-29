import 'package:androidapp_flutter/PeopleList.dart';
import 'package:androidapp_flutter/map.dart';
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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PostListScreen(),
    MapScreen(),
    AuthorsPage()
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
            icon: Icon(Icons.person),
            label: 'Authors',
          ),
        ],
      ),
    );
  }

}
