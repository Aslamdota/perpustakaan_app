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
      child: Column(
        children: [
          // Header dengan logo profile
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Ganti dengan path gambar profile
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
          // Menu Notifikasi
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () => handleNavigation(context, 'notifications'),
          ),
          // Menu Tambah Peminjaman
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Peminjaman'),
            onTap: () => handleNavigation(context, 'add_loan'),
          ),
          // Menu Ganti Tema
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Ganti Tema'),
            onTap: onToggleTheme,
          ),
          // Menu Pengaturan
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () => handleNavigation(context, 'settings'),
          ),
          const Spacer(), // Menempatkan Logout di bagian bawah
          const Divider(), // Garis pemisah
          // Menu Logout
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