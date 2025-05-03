import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://perpustakaan-api.example.com';

  Future<List<dynamic>> getBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<dynamic>> getMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/members'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<List<dynamic>> getLoans() async {
    final response = await http.get(Uri.parse('$baseUrl/loans'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load loans');
    }
  }

  Future<List<dynamic>> getReturns() async {
    final response = await http.get(Uri.parse('$baseUrl/returns'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load returns');
    }
  }

  

  // Tambahkan metode untuk peminjaman dan pengembalian
}