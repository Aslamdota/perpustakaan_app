import 'package:flutter/material.dart';
import 'package:library_frontend/screens/home_screen.dart';
import 'package:library_frontend/screens/loan_list_screen.dart';
import 'package:library_frontend/screens/login_screen.dart';
import 'package:library_frontend/screens/book_list_screen.dart';
import 'package:library_frontend/screens/member_list_screen.dart';
import 'package:library_frontend/screens/return_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/book': (context) => const BookListScreen(),
        '/member': (context) => MemberListScreen(),
        '/loan': (context) => LoanListScreen(),
        '/return': (context) => ReturnListScreen(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}
