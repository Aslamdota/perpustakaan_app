// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _booksFuture;
  String? _memberId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadBooks();
    _loadMemberId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = apiService.getBooks();
    });
  }

  Future<void> _loadMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    final memberId = prefs.getString('member_id');
    if (memberId != null) {
      setState(() {
        _memberId = memberId;
      });
    }
  }

  void _showBookDetails(BuildContext context, Map<String, dynamic> book) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.book, size: 48, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          book['title'] ?? 'Tanpa Judul',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 12),
                  _infoRow('Penulis', book['author'], textColor),
                  _infoRow('Penerbit', book['publisher'], textColor),
                  _infoRow('ISBN', book['isbn'], textColor),
                  _infoRow('Tahun Terbit', book['publication_year']?.toString(), textColor),
                  _infoRow('Stok Tersedia', book['stock']?.toString(), textColor),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleBookLoan(context, book),
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Pinjam Buku'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: const Color.fromARGB(255, 170, 140, 223),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleBookLoan(BuildContext context, Map<String, dynamic> book) async {
    try {
      Navigator.pop(context);

      if (_memberId == null || _memberId!.isEmpty) {
        _showSnackBar(context, 'Anda harus login terlebih dahulu');
        return;
      }

      final response = await apiService.createLoan(_memberId!, book['id']);

      if (response['status'] == 'success') {
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'Permintaan peminjaman berhasil dibuat');
        await Future.delayed(const Duration(milliseconds: 1500));
        _loadBooks();
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushNamed(context, '/loans');
        }
      } else {
        _showSnackBar(context, response['message'] ?? 'Gagal meminjam buku');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, 'Error: ${e.toString()}');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _infoRow(String label, String? value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, dynamic book, {bool isFavorite = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(
          isFavorite ? Icons.favorite : Icons.book,
          color: isFavorite ? Colors.red : Colors.deepPurple,
          size: 32,
        ),
        title: Text(
          book['title'] ?? 'Tanpa Judul',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Stok: ${book['stock']?.toString() ?? '0'}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showBookDetails(context, book),
      ),
    );
  }

  bool _matchesSearch(dynamic book) {
    if (_searchQuery.isEmpty) return true;

    final title = (book['title'] ?? '').toString().toLowerCase();
    final author = (book['author'] ?? '').toString().toLowerCase();
    final category = (book['category'] ?? '').toString().toLowerCase();
    final publisher = (book['publisher'] ?? '').toString().toLowerCase();

    return title.contains(_searchQuery) ||
        author.contains(_searchQuery) ||
        category.contains(_searchQuery) ||
        publisher.contains(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    appBar: AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
      elevation: 0,
      title: const Text('📚 Daftar Buku'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _loadBooks();
            _loadMemberId();
          },
        ),
      ],
    ),
      body: FutureBuilder<List<dynamic>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat data buku'),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadBooks,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('📖 Tidak ada buku yang tersedia.'),
            );
          }

          final books = snapshot.data!;
          final favoriteBooks = books.where((book) => book['is_favorite'] == true).toList();
          final otherBooks = books.where((book) => book['is_favorite'] != true).toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 🔍 Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari judul, penulis, kategori...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ❤️ Buku Favorit (filtered)
              if (favoriteBooks.where(_matchesSearch).isNotEmpty) ...[
                const Text('❤️ Buku Favorit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...favoriteBooks.where(_matchesSearch).map((book) => _buildBookCard(context, book, isFavorite: true)),
                const Divider(height: 32),
              ],

              // 📘 Semua Buku (filtered)
              const Text('📘 Semua Buku', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...otherBooks.where(_matchesSearch).map((book) => _buildBookCard(context, book)),
            ],
          );
        },
      ),
    );
  }
}