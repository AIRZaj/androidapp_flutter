import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';

class Post {
  final int id;
  final String imie;
  final String nazwisko;
  final String pokoj;
  final String tytul;
  final String telefon;
  final String budynek;
  final String mail;
  final String konsultacje;
  final String linkDoSerwisuUsos;

  Post({
    required this.id,
    required this.imie,
    required this.nazwisko,
    required this.pokoj,
    required this.tytul,
    required this.telefon,
    required this.budynek,
    required this.mail,
    required this.konsultacje,
    required this.linkDoSerwisuUsos,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      imie: json['imie'] ?? '',
      nazwisko: json['nazwisko'] ?? '',
      pokoj: json['pokoj'] ?? '',
      tytul: json['tytul'] ?? '',
      telefon: json['telefon'] ?? '',
      budynek: json['budynek'] ?? '',
      mail: json['mail'] ?? '',
      konsultacje: json['konsultacje'] ?? '',
      linkDoSerwisuUsos: json['link_do_serwisu_usos'] ?? '',
    );
  }
}

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _futurePosts;

  Future<List<Post>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://grupa2.android.mzelent.pl/persons/'));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Błąd podczas pobierania danych');
    }
  }

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista Postów')),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Brak danych'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.imie),
                subtitle: Text('ID: ${post.id}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: post),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
