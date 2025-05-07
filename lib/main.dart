import 'package:flutter/material.dart';
import 'package:library_frontend/screens/loan_list_screen.dart';
import 'package:library_frontend/screens/member_list_screen.dart';
import 'package:library_frontend/screens/return_list_screen.dart';
import 'package:library_frontend/screens/setting_screen.dart';
import 'package:library_frontend/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/book_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is logged in by checking for a stored token
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/books': (context) => const BookListScreen(),
        '/members': (context) => const MemberListScreen(),
        '/loans': (context) => const LoanListScreen(),
        '/returns': (context) => const ReturnListScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/settings': (context) => const SettingsScreen(),
        'logout': (context) {
            final apiService = ApiService();
            apiService.logout().then((success) {
              if (success) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal logout')),
                );
              }
            });
            return const SizedBox.shrink(); // Menghindari return widget sebelum selesai
          },
      },
    );
  }
}


