import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';
import '../services/article_service.dart';

// Provider to get a stream of all articles (metadata)
final articlesListProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final articleService = ref.watch(articleServiceProvider);
  return articleService.getArticles();
});

// Provider to get a single article with all its topics
final articleDetailProvider = FutureProvider.family
    .autoDispose<Article?, String>((ref, articleId) {
      final articleService = ref.watch(articleServiceProvider);
      return articleService.getArticleWithTopics(articleId);
    });
