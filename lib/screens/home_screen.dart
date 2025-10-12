import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../widgets/news_tile.dart'; // Add this import

class HomeScreen extends ConsumerWidget {
  final String category;
  const HomeScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use storyIdsProvider instead of newsListProvider
    final storyIdsAsync = ref.watch(storyIdsProvider(category));

    return Scaffold(
      appBar: AppBar(title: Text('${category[0].toUpperCase()}${category.substring(1)} Stories')),
      body: storyIdsAsync.when(
        data: (ids) => ListView.builder(
          itemCount: ids.take(20).length, // Limit for performance
          itemBuilder: (context, index) {
            final id = ids[index];
            return NewsTile(newsId: id);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}