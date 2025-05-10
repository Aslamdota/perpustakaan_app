import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _categoriesFuture;
  late Future<List<dynamic>> _latestBooksFuture;
  String userName = 'User'; // Default nama pengguna

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Memuat nama pengguna dari SharedPreferences
    _categoriesFuture = apiService.getCategories(); // Memuat kategori
    _latestBooksFuture = apiService.getLatestBooks(); // Memuat buku terbaru
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User'; // Ambil nama dari SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Access All Your Favorite Reads',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<dynamic>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Gagal memuat kategori');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada kategori tersedia');
                  } else {
                    final categories = snapshot.data!;
                    return SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: categories
                            .map((category) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Chip(label: Text(category['name'])),
                                ))
                            .toList(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'New Book',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: _latestBooksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Gagal memuat buku terbaru');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada buku terbaru');
                  } else {
                    final books = snapshot.data!;
                    return SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                children: [
                                  Image.network(
                                    book['cover_url'], // Pastikan API mengembalikan URL gambar
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}