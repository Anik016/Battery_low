// lib/utils/supabase_config.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static final client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await client.from('products').select();
    if (response.isEmpty) return [];
    return List<Map<String, dynamic>>.from(response);
  }
}