import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/news_entity.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity article;

  const NewsDetailPage({super.key, required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.parse(article.articleUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 250,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title.isNotEmpty ? article.title : 'No Title',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    article.author.isNotEmpty
                        ? article.author
                        : 'Unknown Author',
                  ),

                  const SizedBox(height: 8),

                  Text(
                    article.publishedAt.isNotEmpty
                        ? article.publishedAt
                        : 'No Date',
                  ),

                  const SizedBox(height: 16),

                  Text(
                    article.description.isNotEmpty
                        ? article.description
                        : 'No Description',
                  ),

                  const SizedBox(height: 16),

                  Text(
                    article.content.isNotEmpty ? article.content : 'No Content',
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openArticle,
                      child: const Text('Read Full Article'),
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
