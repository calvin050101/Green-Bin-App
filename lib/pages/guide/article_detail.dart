import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/article_provider.dart';
import '../../widgets/back_button.dart';
import '../../widgets/cust_container.dart';
import 'package:green_bin/models/article_topic_model.dart';

import 'article_content.dart';

class ArticleDetailPage extends ConsumerWidget {
  final String articleName;
  final String articleId;

  const ArticleDetailPage({
    super.key,
    required this.articleName,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

                  topics!.isEmpty
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: Text('No articles published yet.'),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          final topic = topics[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: articleLinkContainer(topic, context),
                          );
                        },
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleContentPage(articleTopic: topic!),
          ),
        );
      },
      child: CustContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                topic?.title ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
