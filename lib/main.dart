import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/news_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatelessWidget {
  const NewsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hacker News'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Top'),
              Tab(text: 'New'),
              Tab(text: 'Best'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewsListScreen(type: 'topstories'),
            NewsListScreen(type: 'newstories'),
            NewsListScreen(type: 'beststories'),
          ],
        ),
      ),
    );
  }
}