import 'package:cloud_firestore/cloud_firestore.dart';
import 'article_topic_model.dart';

class Article {
  final String id;
  final String title;
  final String? imageUrl;
  final DateTime publishedDate;
  final String? summary;
  final List<ArticleTopic>? topics;

  Article({
    required this.id,
    required this.title,
    required this.publishedDate,
    this.imageUrl,
    this.summary,
    this.topics,
  });

  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['title'] as String,
      publishedDate: (data['publishedDate'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] as String?,
      summary: data['summary'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'summary': summary,
      'publishedDate': Timestamp.fromDate(publishedDate),
    };
  }

  // Helper to create a new Article instance with topics loaded
  Article copyWithTopics({List<ArticleTopic>? topics}) {
    return Article(
      id: id,
      title: title,
      publishedDate: publishedDate,
      imageUrl: imageUrl,
      summary: summary,
      topics: topics ?? this.topics,
    );
  }
}
