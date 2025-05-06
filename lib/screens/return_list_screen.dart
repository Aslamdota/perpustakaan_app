import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReturnListScreen extends StatefulWidget {
  const ReturnListScreen({super.key});

  @override
  State<ReturnListScreen> createState() => _ReturnListScreenState();
}

class _ReturnListScreenState extends State<ReturnListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _returnsFuture;

  @override
  void initState() {
    super.initState();
    _loadReturns();
  }

  void _loadReturns() {
    setState(() {
      _returnsFuture = apiService.getReturns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengembalian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReturns,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _returnsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat data pengembalian'),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadReturns,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada pengembalian yang tersedia.'),
            );
          } else {
            final returns = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: returns.length,
              itemBuilder: (context, index) {
                final returnItem = returns[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.assignment_return, size: 40.0),
                    title: Text(returnItem['book_title'] ?? 'No Title'),
                    subtitle: Text('Dikembalikan oleh: ${returnItem['member_name'] ?? 'Unknown'}'),
                    trailing: Text('Tanggal: ${returnItem['return_date'] ?? 'N/A'}'),
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