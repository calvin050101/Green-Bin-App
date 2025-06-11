// models/article_topic_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleTopic {
  final String id;
  final String title;
  final String content;
  final int order;

  ArticleTopic({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });

  factory ArticleTopic.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleTopic(
      id: doc.id,
      title: data['title'] as String,
      content: data['content'] as String,
      order: data['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'title': title, 'content': content, 'order': order};
  }
}
