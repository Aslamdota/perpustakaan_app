import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReturnListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  ReturnListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pengembalian'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getReturns(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No returns found'));
          } else {
            final returns = snapshot.data!;
            return ListView.builder(
              itemCount: returns.length,
              itemBuilder: (context, index) {
                final returnItem = returns[index];
                return ListTile(
                  title: Text(returnItem['book_title']),
                  subtitle: Text('Returned by: ${returnItem['member_name']}'),
                  trailing: Text('Date: ${returnItem['return_date']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}