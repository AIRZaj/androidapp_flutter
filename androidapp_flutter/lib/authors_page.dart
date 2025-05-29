import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildAuthorCard(
              context,
              'Szymon Nadbrzeżny',
              'https://github.com/SzymonNadbrzezny',
              'https://github.com/SzymonNadbrzezny.png',
            ),
            const SizedBox(height: 16),
            _buildAuthorCard(
              context,
              'Jakub Niemir',
              'https://github.com/jaknie10',
              'https://github.com/jaknie10.png',
            ),
            const SizedBox(height: 16),
            _buildAuthorCard(
              context,
              'Patryk Czarnecki',
              'https://github.com/patchaq',
              'https://github.com/patchaq.png',
            ),
            const SizedBox(height: 16),
            _buildAuthorCard(
              context,
              'Rafał Kiljan',
              'https://github.com/RafalKiljan',
              'https://github.com/RafalKiljan.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorCard(
    BuildContext context,
    String name,
    String githubUrl,
    String avatarUrl,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _launchURL(githubUrl),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'GitHub Profile',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
