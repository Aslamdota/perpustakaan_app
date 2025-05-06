import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';
  final String token = 'YOUR_ACCESS_TOKEN'; // Ganti dengan token autentikasi Anda

  // Helper untuk membuat header dengan autentikasi
  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Ambil daftar buku
  Future<List<dynamic>> getBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'), headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan struktur JSON sesuai
    } else {
      throw Exception('Failed to load books: ${response.body}');
    }
  }

  // Ambil daftar anggota
  Future<List<dynamic>> getMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/members'), headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan struktur JSON sesuai
    } else {
      throw Exception('Failed to load members: ${response.body}');
    }
  }

  // Ambil daftar peminjaman
  Future<List<dynamic>> getLoans() async {
    final response = await http.get(Uri.parse('$baseUrl/loans'), headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan struktur JSON sesuai
    } else {
      throw Exception('Failed to load loans: ${response.body}');
    }
  }

  // Ambil daftar pengembalian
  Future<List<dynamic>> getReturns() async {
    final response = await http.get(Uri.parse('$baseUrl/returns'), headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan struktur JSON sesuai
    } else {
      throw Exception('Failed to load returns: ${response.body}');
    }
  }

  // Tambahkan peminjaman baru
  Future<void> createLoan(Map<String, dynamic> loanData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans'),
      headers: _headers(),
      body: json.encode(loanData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create loan: ${response.body}');
    }
  }

  // Tambahkan pengembalian baru
  Future<void> createReturn(Map<String, dynamic> returnData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/returns'),
      headers: _headers(),
      body: json.encode(returnData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create return: ${response.body}');
    }
  }

  //login
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Simpan token atau sesi pengguna
      jsonDecode(response.body);
      // Contoh: Simpan token ke shared preferences
      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.setString('token', data['token']);
      // });
      return true;
    } else {
      return false;
    }
  }

  //logout
  Future<bool> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Hapus token atau sesi pengguna
      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.remove('token');
      // });
      return true;
    } else {
      return false;
    }
  }
}