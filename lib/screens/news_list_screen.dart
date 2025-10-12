import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../widgets/news_tile.dart';

class NewsListScreen extends ConsumerWidget {
  final String type; // "topstories", "newstories", "beststories"
  
  const NewsListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyIdsAsync = ref.watch(storyIdsProvider(type));

    return Scaffold(
      appBar: AppBar(
        title: Text('${type[0].toUpperCase()}${type.substring(1)} Stories'),
      ),
      body: storyIdsAsync.when(
        data: (ids) {
          // Take first 20 for performance
          final limitedIds = ids.take(20).toList();
          
          return ListView.builder(
            itemCount: limitedIds.length,
            itemBuilder: (context, index) {
              final id = limitedIds[index];
              return NewsTile(newsId: id);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.refresh(storyIdsProvider(type)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}