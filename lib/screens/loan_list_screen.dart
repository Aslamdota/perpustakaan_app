import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'pickup_screen.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  void _loadLoans() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getLoans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada peminjaman yang tersedia.'),
            );
          } else {
            final loans = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.library_books),
                    title: Text(loan['book_title'] ?? 'No Title'),
                    subtitle: Text('Status: ${loan['status']}'),
                    trailing: loan['status'] == 'Approved'
                        ? ElevatedButton(
                            onPressed: () {
                              // Navigasi ke halaman ambil buku
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PickupScreen(loanId: loan['id']),
                                ),
                              );
                            },
                            child: const Text('Ambil Buku'),
                          )
                        : null,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}