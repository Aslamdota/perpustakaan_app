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

  Future<void> _init() async {
    await _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<void> setToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
  }

  Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('account_name');
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getStoredAccountName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('account_name');
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getMembers() async {
    try {
      await _loadToken(); // pastikan token dimuat
      final response = await http.get(
        Uri.parse('$baseUrl/members'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data; // langsung return list
        } else {
          throw Exception('Unexpected data format: not a list');
        }
      } else {
        throw Exception('Failed to fetch members: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  Future<List<dynamic>> getBooks() async {
    try {
      await _loadToken();
      final response = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data']['data'] ?? [];
        } else {
          throw Exception('API Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

//  method getFavoriteBooks
  Future<List<dynamic>> getFavoriteBooks(String memberId) async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/recomendation/$memberId'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['data'] ?? [];
      } else {
        throw Exception('API error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load favorite books: ${response.statusCode}');
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

  Future<Map<String, dynamic>> createLoan(int bookId) async {
    final url = Uri.parse('$baseUrl/loans');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'book_id': bookId}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat peminjaman');
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
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['data']['access_token'];
        final user = responseData['data']['user'];
        final accountName =
            user['account_name']; // Pastikan key ini ada di response

        if (token != null && token.isNotEmpty) {
          await setToken(token);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('account_name', accountName ?? '');

          return {
            'success': true,
            'message': responseData['message'] ?? 'Login sukses',
            'data': {
              'access_token': token,
              'user': user,
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Token tidak ditemukan dalam respons',
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

  Future<bool> logout() async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'), // Endpoint benar
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      await clearToken(); // hapus token & account name
      return true;
    } else {
      return false;
    }
  }
}
