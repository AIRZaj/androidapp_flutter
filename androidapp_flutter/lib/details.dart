import 'package:flutter/material.dart';
import 'PeopleList.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  String _formatPhoneNumber(String phone) {
    // Remove any spaces, dashes, or parentheses
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // If number doesn't start with +, add +48 (Poland country code)
    if (!cleaned.startsWith('+')) {
      cleaned = '+48$cleaned';
    }
    return cleaned;
  }

  Future<void> _launchUrl(String scheme,
      {LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      // Format the URL based on the scheme
      String formattedScheme = scheme;
      if (scheme.startsWith('tel:')) {
        String phone = scheme.substring(4); // Remove 'tel:' prefix
        formattedScheme = 'tel:${_formatPhoneNumber(phone)}';
      } else if (scheme.startsWith('sms:')) {
        String phone = scheme.substring(4); // Remove 'sms:' prefix
        formattedScheme = 'sms:${_formatPhoneNumber(phone)}';
      } else if (scheme.startsWith('mailto:')) {
        // Ensure email URL is properly formatted
        formattedScheme = scheme.replaceAll(' ', '');
      }

      final uri = Uri.parse(formattedScheme);
      debugPrint('Attempting to launch URL: $uri');

      // Try to launch the URL directly without checking canLaunchUrl first
      bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) {
        debugPrint('Failed to launch URL: $uri');
        if (scheme.startsWith('tel:')) {
          throw 'Nie można otworzyć aplikacji telefonicznej';
        } else if (scheme.startsWith('mailto:')) {
          throw 'Nie można otworzyć aplikacji pocztowej';
        } else if (scheme.startsWith('sms:')) {
          throw 'Nie można otworzyć aplikacji SMS';
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // You might want to show a SnackBar or AlertDialog here to inform the user
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
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 45, 105), width: 3),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    const AssetImage('assets/avatar_placeholder.png'),
              ),
            ),

            const SizedBox(height: 16),

            // Tytuł + imię + nazwisko
            Text(
              '${post.tytul ?? ''}. ${post.imie ?? ''} ${post.nazwisko ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (post.mail != null && post.mail!.isNotEmpty)
              Text(
                post.mail!,
                style: const TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 20),

            // Biała karta z dwoma kolumnami i ikonami
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    // Zakład i pokój w dwóch kolumnach
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("Budynek",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(post.budynek ?? 'Brak',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                            const Text("Pokój",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(post.pokoj ?? 'Brak',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Ikony
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (post.telefon != null && post.telefon!.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.phone),
                            color: const Color.fromARGB(255, 0, 45, 105),
                            iconSize: 30,
                            onPressed: () => _launchUrl('tel:${post.telefon}',
                                mode: LaunchMode.platformDefault),
                          ),
                        if (post.telefon != null && post.telefon!.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.message),
                            color: const Color.fromARGB(255, 0, 45, 105),
                            iconSize: 30,
                            onPressed: () => _launchUrl('sms:${post.telefon}',
                                mode: LaunchMode.platformDefault),
                          ),
                        if (post.mail != null && post.mail!.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.email),
                            color: const Color.fromARGB(255, 0, 45, 105),
                            iconSize: 30,
                            onPressed: () => _launchUrl('mailto:${post.mail}',
                                mode: LaunchMode.platformDefault),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Konsultacje
            if (post.konsultacje != null && post.konsultacje!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.schedule, color: Colors.grey),
                  title: const Text('Konsultacje'),
                  subtitle: Text(post.konsultacje!),
                ),
              ),

            // Link do USOS
            if (post.linkDoSerwisuUsos != null &&
                post.linkDoSerwisuUsos!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.link,
                      color: Color.fromARGB(255, 0, 45, 105)),
                  title: const Text('Zobacz profil w USOS'),
                  subtitle: Text(post.linkDoSerwisuUsos!),
                  onTap: () {
                    _launchUrl(post.linkDoSerwisuUsos!);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
