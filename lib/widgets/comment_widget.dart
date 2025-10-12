import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';

class CommentWidget extends ConsumerWidget {
  final int commentId;
  
  const CommentWidget({super.key, required this.commentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentAsync = ref.watch(newsProvider(commentId));

    return commentAsync.when(
      data: (comment) {
        // Some comments might be dead or deleted
        if (comment.text == null || comment.by == '[deleted]') {
          return const SizedBox.shrink(); // Hide deleted comments
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.by,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comment.text ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                
                // Nested comments (replies)
                if (comment.kids != null && comment.kids!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      children: comment.kids!.map((kidId) {
                        return CommentWidget(commentId: kidId);
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: LinearProgressIndicator(),
      ),
      error: (e, st) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Error loading comment'),
      ),
    );
  }
}