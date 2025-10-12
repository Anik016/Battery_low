import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../widgets/comment_widget.dart';

class NewsDetailScreen extends ConsumerWidget {
  final int newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(newsId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Details'),
        backgroundColor: Colors.orange,
      ),
      body: newsAsync.when(
        data: (news) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Story Title
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Story Metadata
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('By: ${news.by}'),
                    const SizedBox(width: 16),
                    Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('Score: ${news.score}'),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(_formatTime(news.time)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // URL Section - Make it prominent
                if (news.url != null) ...[
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'External Link:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // You can add url_launcher later to open the URL
                              _showUrlDialog(context, news.url!);
                            },
                            child: Text(
                              news.url!,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Story Text/Content
                if (news.text != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Story Content:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _parseHtmlText(news.text!),
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else if (news.url == null) ...[
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No content available for this story.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Comments Section
                if (news.kids != null && news.kids!.isNotEmpty) ...[
                  const Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...news.kids!.map((commentId) {
                    return CommentWidget(commentId: commentId);
                  }).toList(),
                ] else ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No comments yet',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading story',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                '$e',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.refresh(newsProvider(newsId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format Unix timestamp to readable time
  String _formatTime(int unixTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Helper method to parse HTML text (remove HTML tags)
  String _parseHtmlText(String htmlText) {
    // Simple HTML tag removal - you can use a package like html_unescape for better handling
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .trim();
  }

  // Show URL dialog (temporary until you add url_launcher)
  void _showUrlDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Link'),
        content: Text('Would you like to visit: $url?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add url_launcher to open the URL
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Would open: $url'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}