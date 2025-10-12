import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../screens/news_detail_screen.dart';

class NewsTile extends ConsumerWidget {
  final int newsId;
  const NewsTile({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(newsId));

    return newsAsync.when(
      data: (news) => Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.orange),
                Text(
                  '${news.score}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          title: Text(
            news.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('By ${news.by}'),
              if (news.kids != null && news.kids!.isNotEmpty)
                Text('${news.kids!.length} comments'),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(newsId: news.id),
              ),
            );
          },
        ),
      ),
      loading: () => const Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ListTile(
          title: LinearProgressIndicator(),
        ),
      ),
      error: (e, st) => Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        color: Colors.red[50],
        child: const ListTile(
          leading: Icon(Icons.error, color: Colors.red),
          title: Text('Error loading story'),
        ),
      ),
    );
  }
}