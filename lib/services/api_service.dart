import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';
  String? token;

  ApiService() {
    _init();
  }

  // Inisialisasi async
  Future<void> _init() async {
    await _loadToken();
  }

  // Load token dari SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  // Simpan token ke SharedPreferences dan ke memori
  Future<void> setToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
  }

  // Hapus token dari SharedPreferences
  Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Ambil token dari SharedPreferences dari luar
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Header HTTP dengan atau tanpa token
  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getBooks() async {
    try {
      await _loadToken();
      final response = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: _headers(),
      );

      if (kDebugMode) {
        print('API Response: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final books = data['data']['data'] ?? [];
          if (kDebugMode) {
            print('Successfully parsed ${books.length} books');
          }
          return books;
        } else {
          throw Exception('API returned error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getBooks: $e');
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getMembers() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/members'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load members: ${response.body}');
    }
  }

  Future<List<dynamic>> getLoans() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/loans'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load loans: ${response.body}');
    }
  }

  Future<List<dynamic>> getReturns() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/returns'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Failed to load returns: ${response.body}');
    }
  }

  Future<void> createLoan(Map<String, dynamic> loanData) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/loans'),
      headers: _headers(),
      body: json.encode(loanData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create loan: ${response.body}');
    }
  }

  Future<void> createReturn(Map<String, dynamic> returnData) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/returns'),
      headers: _headers(),
      body: json.encode(returnData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create return: ${response.body}');
    }
  }

  // Login dan simpan token
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    const String apiUrl = 'http://127.0.0.1:8000/api/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (kDebugMode) {
        print('Raw API response: ${response.body}');
      } // Debug

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Correct token access based on actual API response
        final token = responseData['data']['access_token'];

        if (token != null && token.isNotEmpty) {
          await setToken(token);
          return {
            'success': true,
            'message': responseData['message'] ?? 'Login sukses',
            'data': {
              'access_token': token,
              'user': responseData['data']['user']
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Token tidak ditemukan dalam respons'
          };
        }
      } else {
        final error = responseData['message'] ??
            'Login gagal (Status: ${response.statusCode})';
        return {'success': false, 'message': error};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Logout dan hapus token
  Future<bool> logout() async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      await clearToken();
      return true;
    } else {
      return false;
    }
  }
}
