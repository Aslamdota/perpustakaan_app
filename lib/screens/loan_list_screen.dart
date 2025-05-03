import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoanListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  LoanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Peminjaman'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getLoans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No loans found'));
          } else {
            final loans = snapshot.data!;
            return ListView.builder(
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];
                return ListTile(
                  title: Text(loan['book_title']),
                  subtitle: Text('Borrowed by: ${loan['member_name']}'),
                  trailing: Text('Due: ${loan['due_date']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}