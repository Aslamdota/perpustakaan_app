import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;

  const Sidebar({super.key, required this.onNavigate});

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
            onTap: () => onNavigate('home'),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Books'),
            onTap: () => onNavigate('books'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Members'),
            onTap: () => onNavigate('members'),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Loans'),
            onTap: () => onNavigate('loans'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_return),
            title: const Text('Returns'),
            onTap: () => onNavigate('returns'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              onNavigate('logout');
              Navigator.pushReplacementNamed(context, '/login'); // Navigasi ke login
            },
          ),
        ],
      ),
    );
  }
}