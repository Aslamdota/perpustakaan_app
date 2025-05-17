import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../screens/book_list_screen.dart';

class ModernHomeContent extends StatefulWidget {
  const ModernHomeContent({super.key});

  @override
  State<ModernHomeContent> createState() => _ModernHomeContentState();
}

class _ModernHomeContentState extends State<ModernHomeContent> {
  final ApiService apiService = ApiService();

  late Future<List<dynamic>> _categoriesFuture;
  late Future<List<dynamic>> _recommendationFuture;
  String memberName = 'Member';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = apiService.getCategories();
    _recommendationFuture = apiService.getLatestBooks();
    _loadMemberName();
  }

  Future<void> _loadMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('member_name');
    if (name != null && name.isNotEmpty) {
      setState(() {
        memberName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salam personal
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                // ignore: deprecated_member_use
                backgroundColor: Colors.indigo.withOpacity(0.1),
                child: const Icon(Icons.person, size: 36, color: Colors.indigo),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $memberName 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Selamat datang di Perpustakaan!',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Kategori Card dari API
          FutureBuilder<List<dynamic>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 110,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return const SizedBox(
                  height: 110,
                  child: Center(child: Text('Gagal memuat kategori')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox(
                  height: 110,
                  child: Center(child: Text('Tidak ada kategori')),
                );
              }
              final categories = snapshot.data!;
              return SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Theme.of(context).cardColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          // Navigasi sesuai kategori
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BookListScreen(), // Bisa filter kategori di BookListScreen
                            ),
                          );
                        },
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.category, size: 36, color: Colors.indigo),
                              const SizedBox(height: 10),
                              Text(
                                cat['name'] ?? '-',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // Rekomendasi Buku dari API
          Text(
            'Rekomendasi Hari Ini',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<dynamic>>(
            future: _recommendationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Gagal memuat rekomendasi buku'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada rekomendasi buku.'));
              }
              final books = snapshot.data!;
              return Column(
                children: books.take(5).map((book) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.menu_book, color: Colors.indigo, size: 32),
                      ),
                      title: Text(book['title'] ?? 'Tanpa Judul'),
                      subtitle: Text(book['author'] ?? '-'),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                      onTap: () {
                        // Navigasi ke detail buku jika ada
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}