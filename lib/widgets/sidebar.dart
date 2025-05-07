import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;

  const Sidebar({super.key, required this.onNavigate});

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text(""),
            accountEmail: const Text(""),
            currentAccountPicture: const CircleAvatar(
              backgroundImage:
                  AssetImage('assets/profile.jpg'), // Ganti sesuai asetmu
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Navigasi',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                _buildItem(context, Icons.home, 'Home', 'home'),
                _buildItem(context, Icons.book, 'Books', 'books'),
                _buildItem(context, Icons.people, 'Members', 'members'),
                _buildItem(context, Icons.library_books, 'Loans', 'loans'),
                _buildItem(
                    context, Icons.assignment_return, 'Returns', 'returns'),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Lainnya',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                _buildItem(context, Icons.logout, 'Logout', 'logout'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
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
