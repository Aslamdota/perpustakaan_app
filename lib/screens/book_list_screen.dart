import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = apiService.getBooks().then((books) {
        if (kDebugMode) {
          print('Books loaded successfully: $books');
        }
        return books;
      }).catchError((error) {
        if (kDebugMode) {
          print('Error loading books: $error');
        }
        throw error; // Re-throw to let FutureBuilder handle it
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Buku'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (kDebugMode) {
            print('Builder called. ConnectionState: ${snapshot.connectionState}');
          }
          if (kDebugMode) {
            print('HasData: ${snapshot.hasData}, Data: ${snapshot.data}');
          }
          if (kDebugMode) {
            print('HasError: ${snapshot.hasError}, Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading books'),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadBooks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found'));
          }

          final books = snapshot.data!;
          if (kDebugMode) {
            print('Building list with ${books.length} books');
          }

          return RefreshIndicator(
            onRefresh: () async => _loadBooks(),
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Ensure scroll works
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                if (kDebugMode) {
                  print('Building item $index: $book');
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(book['title'] ?? 'No Title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: ${book['author'] ?? 'Unknown'}'),
                        Text('Publisher: ${book['publisher'] ?? 'Unknown'}'),
                        Text('ISBN: ${book['isbn'] ?? 'N/A'}'),
                        Text(
                            'Year: ${book['publication_year']?.toString() ?? 'N/A'}'),
                        Text('Stock: ${book['stock']?.toString() ?? '0'}'),
                        if (book['category'] != null)
                          Text('Category: ${book['category']['name']}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle book tap
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
