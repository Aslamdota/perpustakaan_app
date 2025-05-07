import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;

  const Sidebar({super.key, required this.onNavigate});

  void handleNavigation(BuildContext context, String destination) {
    Navigator.pop(context); // Menutup drawer
    if (destination == 'logout') {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      onNavigate(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'Perpustakaan App',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => handleNavigation(context, 'home'),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Books'),
            onTap: () => Navigator.pushNamed(context, '/books'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Members'),
            onTap: () => Navigator.pushNamed(context, '/members'),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Loans'),
            onTap: () => Navigator.pushNamed(context, '/loans'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_return),
            title: const Text('Returns'),
            onTap: () => Navigator.pushNamed(context, '/returns'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pushNamed(context, '/logout'),
          ),
        ],
      ),
    );
  }
}