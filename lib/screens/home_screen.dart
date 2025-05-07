import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'member_list_screen.dart';
import 'loan_list_screen.dart';
import 'return_list_screen.dart';
import '../widgets/sidebar.dart';

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
    const Center(child: Text('Profile')), // Placeholder untuk Profile
  ];

  void toggleTheme() {
    setState(() {
      currentTheme =
          currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void handleSidebarNavigation(String destination) {
    if (destination == 'logout') {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (destination == 'settings') {
      Navigator.pushNamed(context, '/settings');
    }
    // Tambahkan navigasi lainnya jika diperlukan
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
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: toggleTheme,
            ),
          ],
        ),
        drawer: Sidebar(
          onNavigate: handleSidebarNavigation,
          onToggleTheme: toggleTheme,
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