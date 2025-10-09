import 'package:flutter/material.dart';
import 'pages/chat_page.dart';

void main() {
  runApp(const LocalAIApp());
}

class LocalAIApp extends StatelessWidget {
  const LocalAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local AI Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ChatPage(),
    );
  }
}
