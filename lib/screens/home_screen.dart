import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'member_list_screen.dart';
import 'loan_list_screen.dart';
import 'profile_screen.dart';
import 'return_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index untuk Bottom Navigation Bar
  ThemeMode currentTheme = ThemeMode.light;

  // Daftar layar untuk setiap tab
  final List<Widget> _screens = [
    const BookListScreen(),
    const MemberListScreen(),
    const LoanListScreen(),
    const ReturnListScreen(),
    const ProfileScreen(), // Tab Profile
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
                    ? Icons.nightlight_round // Ikon bulan untuk mode gelap
                    : Icons.wb_sunny, // Ikon matahari untuk mode terang
              ),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: _screens[_currentIndex], // Tampilkan layar sesuai tab yang dipilih
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
              icon: Icon(Icons.book),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Loans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_return),
              label: 'Returns',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}