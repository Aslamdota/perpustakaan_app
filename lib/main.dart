import 'package:flutter/material.dart';
import 'package:library_frontend/screens/loan_list_screen.dart';
import 'package:library_frontend/screens/member_list_screen.dart';
import 'package:library_frontend/screens/return_list_screen.dart';
import 'package:library_frontend/settings/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/book_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'settings/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        '/': (context) => const HomeScreen(), // Tambahan root route
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/books': (context) => const BookListScreen(),
        '/members': (context) => const MemberListScreen(),
        '/loans': (context) => const LoanListScreen(),
        '/returns': (context) => const ReturnListScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
