import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class HackerNewsApi {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  
  /// Fetch a single Hacker News item by ID
  static Future<News> fetchNewsById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data == null) {
        throw Exception('Item $id not found');
      }
      
      return News.fromJson(data);
    } else {
      throw Exception('Failed to load news $id - Status: ${response.statusCode}');
    }
  }

  /// Fetch story IDs by type (topstories, newstories, beststories)
  static Future<List<int>> fetchStoryIds(String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/${type}.json'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<int>().toList();
    } else {
      throw Exception('Failed to load $type stories');
    }
  }
}