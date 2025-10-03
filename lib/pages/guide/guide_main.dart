import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper/list_view_functions.dart';
import '../../providers/article_provider.dart';
import 'article_detail.dart';
import 'package:green_bin/models/article_model.dart';

class GuideMainPage extends ConsumerWidget {
  const GuideMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsyncValue = ref.watch(articlesListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Waste Guide',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),

      body: articlesAsyncValue.when(
        data: (articles) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listVerticalItems(
                    articles,
                    (context, article) => articleCard(article, context),
                    'No articles published yet.',
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Card articleCard(Article article, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: ListTile(
        leading:
            article.imageUrl != null
                ? CachedNetworkImage(
                  imageUrl: article.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.fitHeight,
                )
                : const Icon(Icons.article, color: Color(0xFF4CAF50)),
        title: Text(
          article.title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          article.summary ?? '-',
          style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            ArticleDetailPage.routeName,
            arguments: {'articleName': article.title, 'articleId': article.id},
          );
        },
      ),
    );
  }
}
