import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> getRelevantNote(
    List<double> questionEmbeddings) async {
  final supabase = Supabase.instance.client;
  final Uri url = Uri.parse(
      '${dotenv.env['PROJECT_URL']!}/rest/v1/rpc/search_notes_by_user');
  String anonKey = dotenv.env['SUPABASE_KEY']!;

  final response = await http.post(
    url,
    headers: {
      'apikey': anonKey,
      'Authorization': 'Bearer $anonKey',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    },
    body: jsonEncode({
      'query_embedding': questionEmbeddings,
      'userid': supabase.auth.currentUser!.id,
    }),
  );

  if (response.statusCode == 200) {
    final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    return data;
  } else {
    return [];
  }
}
