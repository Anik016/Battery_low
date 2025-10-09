import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatService {
 static const String _baseUrl =
    'https://cors-anywhere.herokuapp.com/http://127.0.0.1:1234/v1/chat/completions';


  static Future<String> getResponse(List<Message> history, String prompt) async {
    final messages = history
        .map((msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.text,
            })
        .toList();

    messages.add({'role': 'user', 'content': prompt});

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'qwen2.5-7b-instruct',
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "⚠️ Error: ${response.statusCode}";
    }
  }
}
