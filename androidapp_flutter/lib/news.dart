import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsItem {
  final int id;
  final String category;
  final String date;
  final String title;
  final String subtitle;
  final String imageUrl;

  NewsItem({
    required this.id,
    required this.category,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      category: json['cat'] ?? '',
      date: json['data_pub'] ?? '',
      title: json['lw_1'] ?? '',
      subtitle: json['lw_2'] ?? '',
      imageUrl: json['tresc_1'] ?? '',
    );
  }
}

Future<List<NewsItem>> fetchNews() async {
  final response =
      await http.get(Uri.parse('https://wanatowka.pl/kiosk/api_client.php/'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => NewsItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktualności')),
      body: FutureBuilder<List<NewsItem>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Brak aktualności'));
          }

          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final item = newsList[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.imageUrl.isNotEmpty) Image.network(item.imageUrl),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (item.subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(item.subtitle),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Data: ${item.date}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
