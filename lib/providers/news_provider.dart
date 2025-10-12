import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../services/hacker_news_api.dart';

// Provider for a single news item
final newsProvider = FutureProvider.family<News, int>((ref, id) async {
  return HackerNewsApi.fetchNewsById(id);
});

// Provider for story IDs by type
final storyIdsProvider = FutureProvider.family<List<int>, String>((ref, type) async {
  return HackerNewsApi.fetchStoryIds(type);
});

// Remove the duplicate newsListProvider since we don't need it