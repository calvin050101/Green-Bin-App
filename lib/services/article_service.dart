import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';
import '../models/article_topic_model.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final articleServiceProvider = Provider(
  (ref) => ArticleService(ref.read(firebaseFirestoreProvider)),
);

class ArticleService {
  final FirebaseFirestore _firestore;

  ArticleService(this._firestore);

  // Get all articles (metadata only)
  Stream<List<Article>> getArticles() {
    return _firestore
        .collection('articles')
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList(),
        );
  }

  // Get a single article with its topics
  Future<Article?> getArticleWithTopics(String articleId) async {
    final articleDoc =
        await _firestore.collection('articles').doc(articleId).get();

    if (!articleDoc.exists) {
      return null;
    }

    Article article = Article.fromFirestore(articleDoc);

    // Fetch topics subcollection
    final topicSnapshots =
        await _firestore
            .collection('articles')
            .doc(articleId)
            .collection('topics')
            .orderBy('order')
            .get();

    List<ArticleTopic> topics =
        topicSnapshots.docs
            .map((doc) => ArticleTopic.fromFirestore(doc))
            .toList();

    return article.copyWith(topics: topics);
  }
}
