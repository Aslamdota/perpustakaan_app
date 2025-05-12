import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = 'Memuat...';
  String email = 'Memuat...';
  String phone = 'Memuat...';
  String address = 'Belum tersedia';

  @override
  void initState() {
    super.initState();
    _loadSettingsData();
  }

  Future<void> _loadSettingsData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Tidak diketahui';
      email = prefs.getString('email') ?? 'Tidak diketahui';
      phone = prefs.getString('phone') ?? 'Tidak diketahui';
      address = prefs.getString('address') ?? 'Belum tersedia';
    });
  }

  Widget buildSettingItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Avatar dan Nama Pengguna
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Daftar item setting
          buildSettingItem(Icons.email, 'Email', email),
          buildSettingItem(Icons.phone, 'Telepon', phone),
          buildSettingItem(Icons.home, 'Alamat', address),
        ],
      ),
    );
  }
}
