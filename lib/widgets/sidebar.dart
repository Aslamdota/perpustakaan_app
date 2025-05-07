import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_frontend/screens/login_screen.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onToggleTheme;

  const Sidebar({super.key, required this.onNavigate, required this.onToggleTheme});

  void handleNavigation(BuildContext context, String destination) async {
    Navigator.pop(context); // Tutup drawer dulu

    if (destination == 'logout') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token'); // Hapus token

      // Arahkan ke login screen dan hapus semua stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      onNavigate(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Nama Pengguna',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                Text(
                  'email@example.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () => handleNavigation(context, 'notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Peminjaman'),
            onTap: () => handleNavigation(context, 'add_loan'),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Ganti Tema'),
            onTap: onToggleTheme,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () => handleNavigation(context, 'settings'),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => handleNavigation(context, 'logout'),
          ),
        ],
      ),
    );
  }
}
