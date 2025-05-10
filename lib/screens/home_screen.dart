import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'member_list_screen.dart';
import 'loan_list_screen.dart';
import 'profile_screen.dart';
import '../widgets/home_content.dart'; // Import widget konten utama

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  ThemeMode currentTheme = ThemeMode.light;

  final List<Widget> _screens = [
    const HomeContent(), // Konten utama dipindahkan ke widget terpisah
    const BookListScreen(),
    const MemberListScreen(),
    const LoanListScreen(),
    const ProfileScreen(),
  ];

  void toggleTheme() {
    setState(() {
      currentTheme =
          currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
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
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            IconButton(
              icon: Icon(
                currentTheme == ThemeMode.light
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
              ),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Anggota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Pinjaman',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}