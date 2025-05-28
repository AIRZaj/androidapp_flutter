import 'package:flutter/material.dart';
import 'PeopleList.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  Future<void> _launchUrl(String scheme) async {
    final uri = Uri.parse(scheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar z ramką
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromARGB(255, 0, 45, 105), width: 3),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
              ),
            ),

            const SizedBox(height: 16),

            // Tytuł + imię + nazwisko
            Text(
              '${post.tytul}. ${post.imie} ${post.nazwisko}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              post.mail,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Biała karta z dwoma kolumnami i ikonami
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    // Zakład i pokój w dwóch kolumnach
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Budynek", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(post.budynek, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                         // Pionowa kreska
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 1,
                          color: Colors.grey,
                        ),

                        Column(
                          children: [
                            const Text("Pokój", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(post.pokoj, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Ikony
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone),
                          color: const Color.fromARGB(255, 0, 45, 105),
                          iconSize: 30,
                          onPressed: () => _launchUrl('tel:${post.telefon}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.message),
                          color: const Color.fromARGB(255, 0, 45, 105),
                          iconSize: 30,
                          onPressed: () => _launchUrl('sms:${post.telefon}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.email),
                          color: const Color.fromARGB(255, 0, 45, 105),
                          iconSize: 30,
                          onPressed: () => _launchUrl('mailto:${post.mail}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Konsultacje
            if (post.konsultacje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.schedule, color: Colors.grey),
                  title: const Text('Konsultacje'),
                  subtitle: Text(post.konsultacje),
                ),
              ),

            // Link do USOS
            if (post.linkDoSerwisuUsos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.link, color: const Color.fromARGB(255, 0, 45, 105)),
                  title: const Text('Zobacz profil w USOS'),
                  subtitle: Text(post.linkDoSerwisuUsos),
                  onTap: () {
                    _launchUrl(post.linkDoSerwisuUsos);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
