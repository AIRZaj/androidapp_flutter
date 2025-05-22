import 'package:flutter/material.dart';
import 'main.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Szczegóły')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tytuł:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(post.imie),
            SizedBox(height: 16),
            Text('Treść:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(post.nazwisko),
            Text(post.pokoj),
            Text(post.tytul),
            Text(post.telefon),
            Text(post.budynek),
            Text(post.mail),
            Text(post.konsultacje),
            Text(post.linkDoSerwisuUsos),
          ],
        ),
      ),
    );
  }
}