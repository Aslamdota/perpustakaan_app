import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MemberListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Anggota'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members found'));
          } else {
            final members = snapshot.data!;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  title: Text(member['name']),
                  subtitle: Text(member['email']),
                );
              },
            );
          }
        },
      ),
    );
  }
}