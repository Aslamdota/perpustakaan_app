import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'book_list_screen.dart';
import 'member_list_screen.dart';
import 'loan_list_screen.dart';
import 'return_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentScreen = 'home';
  ThemeMode currentTheme = ThemeMode.light;

  void navigate(String screen) {
    setState(() {
      currentScreen = screen;
    });
    Navigator.pop(context); // Tutup Drawer setelah navigasi
  }

  void toggleTheme() {
    setState(() {
      currentTheme =
          currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Widget _getScreen() {
    switch (currentScreen) {
      case 'books':
        return const BookListScreen();
      case 'members':
        return const MemberListScreen();
      case 'loans':
        return const LoanListScreen();
      case 'returns':
        return const ReturnListScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
  return GridView.count(
    crossAxisCount: 2,
    padding: const EdgeInsets.all(16.0),
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
    children: [
      _buildHomeIcon(
        icon: Icons.book,
        label: 'Books',
        onTap: () => Navigator.pushNamed(context, '/books'),
      ),
      _buildHomeIcon(
        icon: Icons.people,
        label: 'Members',
        onTap: () => Navigator.pushNamed(context, '/members'),
      ),
      _buildHomeIcon(
        icon: Icons.library_books,
        label: 'Loans',
        onTap: () => Navigator.pushNamed(context, '/loans'),
      ),
      _buildHomeIcon(
        icon: Icons.assignment_return,
        label: 'Returns',
        onTap: () => Navigator.pushNamed(context, '/returns'),
        ),
      ],
    );
  }

  Widget _buildHomeIcon(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8.0),
            Text(label,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perpustakaan App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Tambahkan logika refresh
              },
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: toggleTheme,
            ),
          ],
        ),
        drawer: Sidebar(onNavigate: navigate),
        body: _getScreen(),
      ),
    );
  }
}
