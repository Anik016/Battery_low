import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatService {
  static const String _baseUrl = 'http://127.0.0.1:1234/v1/chat/completions';

  static Future<String> getResponse(List<Message> history, String prompt) async {
    final messages = history
        .map((msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.text,
            })
        .toList();

    messages.add({'role': 'user', 'content': prompt});

    print('🔵 Sending request to: $_baseUrl');
    print('🔵 Using model: liquid/lfm2-1.2b');
    print('🔵 Messages: ${messages.length}');

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model': 'liquid/lfm2-1.2b', // Use the exact model ID from your curl test
          'messages': messages,
          'stream': false,
          'max_tokens': 500,
        }),
      );

      print('🟡 Response status: ${response.statusCode}');
      print('🟡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "⚠️ Error: ${response.statusCode} - ${response.reasonPhrase}. Response: ${response.body}";
      }
    } catch (e) {
      print('🔴 Exception: $e');
      return "⚠️ Network error: $e";
    }
  }
}