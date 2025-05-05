import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Buku'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(book['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: ${book['author']}'),
                        Text('Publisher: ${book['publisher']}'),
                        Text('ISBN: ${book['isbn']}'),
                        Text('Year: ${book['publication_year']}'),
                        Text('Stock: ${book['stock']}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Tambahkan logika untuk detail buku jika diperlukan
                    },
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