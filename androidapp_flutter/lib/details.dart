import 'package:flutter/material.dart';
import 'PeopleList.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value ?? 'Brak danych',
            style: TextStyle(fontSize: 16),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Imię', post.imie),
              _buildInfoRow('Nazwisko', post.nazwisko),
              _buildInfoRow('Tytuł', post.tytul),
              _buildInfoRow('Pokój', post.pokoj),
              _buildInfoRow('Budynek', post.budynek),
              _buildInfoRow('Telefon', post.telefon),
              _buildInfoRow('Email', post.mail),
              _buildInfoRow('Konsultacje', post.konsultacje),
              if (post.linkDoSerwisuUsos?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Link do USOS:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          // TODO: Implement URL launcher
                        },
                        child: Text(
                          post.linkDoSerwisuUsos ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
