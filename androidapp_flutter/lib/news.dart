import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class NewsItem {
  final int id;
  final String category;
  final String date;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String content;

  NewsItem({
    required this.id,
    required this.category,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.content,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    String normalizeTitle(String title) {
      if (title.isEmpty) return '';
      return title[0].toUpperCase() + title.substring(1).toLowerCase();
    }

    String buildContent(Map<String, dynamic> json) {
      String content = '';
      int index = 1;
      while (true) {
        String key = 'tresc_$index';
        if (!json.containsKey(key)) break;

        String part = json[key] ?? '';
        if (index == 1 &&
            (part.toLowerCase().endsWith('.jpg') ||
                part.toLowerCase().endsWith('.jpeg') ||
                part.toLowerCase().endsWith('.png') ||
                part.toLowerCase().endsWith('.gif'))) {
          index++;
          continue;
        }
        if (part.isNotEmpty) {
          content += "$part\n\n";
        }
        index++;
      }
      return content;
    }

    String content = buildContent(json);
    String imageUrl = json['tresc_1'] ?? '';
    bool isImage = imageUrl.toLowerCase().endsWith('.jpg') ||
        imageUrl.toLowerCase().endsWith('.jpeg') ||
        imageUrl.toLowerCase().endsWith('.png') ||
        imageUrl.toLowerCase().endsWith('.gif');

    return NewsItem(
      id: json['id'],
      category: json['cat'] ?? '',
      date: json['data_pub'] ?? '',
      title: normalizeTitle(json['lw_1'] ?? ''),
      subtitle: json['lw_2'] ?? '',
      imageUrl: isImage ? imageUrl : '',
      content: content,
    );
  }
}

Future<List<NewsItem>> fetchNews() async {
  final response =
      await http.get(Uri.parse('https://wanatowka.pl/kiosk/api_client.php/'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> newsList = jsonData['news'] ?? [];
    return newsList.map((item) => NewsItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newsItem.imageUrl.isNotEmpty &&
                newsItem.imageUrl != 'null' &&
                newsItem.imageUrl.startsWith('http'))
              CachedNetworkImage(
                imageUrl: newsItem.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (newsItem.subtitle.isNotEmpty)
                    Text(
                      newsItem.subtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    newsItem.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Data: ${newsItem.date}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  void _showNewsDetails(BuildContext context, NewsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.imageUrl.isNotEmpty && item.imageUrl != 'null' && item.imageUrl.startsWith('http'))
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          placeholder: (context, url) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (item.subtitle.isNotEmpty)
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            item.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Data: ${item.date}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                child: InkWell(
                  onTap: () => _showNewsDetails(context, item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.imageUrl.isNotEmpty &&
                          item.imageUrl != 'null' &&
                          item.imageUrl.startsWith('http'))
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            placeholder: (context, url) => Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
