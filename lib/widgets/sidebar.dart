import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onToggleTheme;

  const Sidebar({super.key, required this.onNavigate, required this.onToggleTheme});

  void handleNavigation(BuildContext context, String destination) {
    Navigator.pop(context); // Tutup drawer
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
            onTap: () => handleNavigation(context, 'books'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Members'),
            onTap: () => handleNavigation(context, 'members'),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Loans'),
            onTap: () => handleNavigation(context, 'loans'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_return),
            title: const Text('Returns'),
            onTap: () => handleNavigation(context, 'returns'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => handleNavigation(context, 'logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label),
      hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () => handleNavigation(context, route),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
