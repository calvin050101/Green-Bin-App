import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:green_bin/models/article_topic_model.dart';

import '../../widgets/back_button.dart';

class ArticleContentPage extends StatelessWidget {
  static String routeName = "/article-content";

  const ArticleContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleTopic articleTopic =
        ModalRoute.of(context)!.settings.arguments as ArticleTopic;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              articleTopic.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 40),

            MarkdownBody(
              data: articleTopic.content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
                p: TextStyle(fontFamily: 'OpenSans'),
                strong: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
