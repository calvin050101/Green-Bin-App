import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/list_view_functions.dart';
import 'package:green_bin/widgets/page_direct_container.dart';
import '../../providers/article_provider.dart';
import '../../widgets/back_button.dart';
import 'package:green_bin/models/article_topic_model.dart';

import 'article_content.dart';

class ArticleDetailPage extends ConsumerWidget {
  static String routeName = "/article-detail";

  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final articleName = args['articleName'];
    final articleId = args['articleId'];

    final articleDetailAsyncValue = ref.watch(articleDetailProvider(articleId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: articleDetailAsyncValue.when(
        data: (article) {
          if (article == null) {
            return const Center(child: Text('Article not found.'));
          }

          final topics = article.topics;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    articleName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),

                  listVerticalItems(
                    topics!,
                    (context, topic) =>
                        articleLinkContainer(topic, context),
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

  Widget articleLinkContainer(ArticleTopic? topic, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: PageDirectContainer(
        text: topic?.title ?? '-',
        onTap: () {
          Navigator.pushNamed(
            context,
            ArticleContentPage.routeName,
            arguments: topic,
          );
        },
      ),
    );
  }
}
