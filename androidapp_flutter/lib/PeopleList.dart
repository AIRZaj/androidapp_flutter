import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';

class Post {
  final int id;
  final String? imie;
  final String? nazwisko;
  final String? pokoj;
  final String? tytul;
  final String? telefon;
  final String? budynek;
  final String? mail;
  final String? konsultacje;
  final String? linkDoSerwisuUsos;

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
      imie:
          json['imie'] == 'None' || json['imie'] == null ? null : json['imie'],
      nazwisko: json['nazwisko'] == 'None' || json['nazwisko'] == null
          ? null
          : json['nazwisko'],
      pokoj: json['pokoj'] == 'None' || json['pokoj'] == null
          ? null
          : json['pokoj'],
      tytul: json['tytul'] == 'None' || json['tytul'] == null
          ? null
          : json['tytul'],
      telefon: json['telefon'] == 'None' || json['telefon'] == null
          ? null
          : json['telefon'],
      budynek: json['budynek'] == 'None' || json['budynek'] == null
          ? null
          : json['budynek'],
      mail:
          json['mail'] == 'None' || json['mail'] == null ? null : json['mail'],
      konsultacje: json['konsultacje'] == 'None' || json['konsultacje'] == null
          ? null
          : json['konsultacje'],
      linkDoSerwisuUsos: json['link_do_serwisu_usos'] == 'None' ||
              json['link_do_serwisu_usos'] == null
          ? null
          : json['link_do_serwisu_usos'],
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
  final TextEditingController _searchController = TextEditingController();
  List<Post> _filteredPosts = [];

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

  void _filterPosts(String query, List<Post> posts) {
    setState(() {
      _filteredPosts = posts.where((post) {
        final fullName =
            '${post.tytul ?? ''} ${post.imie ?? ''} ${post.nazwisko ?? ''}'
                .toLowerCase();
        final building = post.budynek?.toLowerCase() ?? '';
        final room = post.pokoj?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return fullName.contains(searchLower) ||
            building.contains(searchLower) ||
            room.contains(searchLower);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          if (_filteredPosts.isEmpty && _searchController.text.isEmpty) {
            _filteredPosts = posts;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Szukaj...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => _filterPosts(value, posts),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post = _filteredPosts[index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                            '${post.tytul ?? ''} ${post.imie ?? ''} ${post.nazwisko ?? ''}'),
                        subtitle: post.budynek != null && post.pokoj != null
                            ? Text(
                                '${post.budynek!.isNotEmpty ? 'Budynek: ${post.budynek}' : ''}\n${post.pokoj!.isNotEmpty ? 'Pokój: ${post.pokoj}' : ''}')
                            : null,
                        trailing:
                            Icon(Icons.chevron_right, color: Colors.grey[400]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(post: post),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
