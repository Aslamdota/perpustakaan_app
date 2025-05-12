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
  late Future<List<dynamic>> _booksFuture;
  String? _memberId;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _loadMemberId();
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
                      const Icon(Icons.book,
                          size: 48, color: Colors.deepPurple),
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
                  _infoRow('Tahun Terbit', book['publication_year']?.toString(),
                      textColor),
                  _infoRow(
                      'Stok Tersedia', book['stock']?.toString(), textColor),
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
                        backgroundColor:
                            const Color.fromARGB(255, 170, 140, 223),
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

  Future<void> _handleBookLoan(
      BuildContext context, Map<String, dynamic> book) async {
    Navigator.pop(context);

    if (_memberId == null || _memberId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus login terlebih dahulu')),
      );
      return;
    }

    try {
      final response = await apiService.createLoan(_memberId!, book['id']);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permintaan peminjaman dikirim')),
        );

        _loadBooks(); // Refresh book list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Gagal meminjam buku')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
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
                  const Text('Gagal memuat data buku'),
                  Text(snapshot.error.toString()),
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
              child: Text('Tidak ada buku yang tersedia.'),
            );
          }

          final books = snapshot.data!;
          final favoriteBooks =
              books.where((book) => book['is_favorite'] == true).toList();
          final otherBooks =
              books.where((book) => book['is_favorite'] != true).toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (favoriteBooks.isNotEmpty) ...[
                const Text(
                  'Buku Favorit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...favoriteBooks.map((book) => Card(
                      color: const Color.fromARGB(255, 255, 248, 225),
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.red),
                        title: Text(book['title'] ?? 'No Title'),
                        subtitle:
                            Text('Stock: ${book['stock']?.toString() ?? '0'}'),
                        onTap: () => _showBookDetails(context, book),
                      ),
                    )),
                const Divider(height: 32),
              ],
              const Text(
                'Semua Buku',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...otherBooks.map((book) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(book['title'] ?? 'No Title'),
                      subtitle:
                          Text('Stock: ${book['stock']?.toString() ?? '0'}'),
                      onTap: () => _showBookDetails(context, book),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
