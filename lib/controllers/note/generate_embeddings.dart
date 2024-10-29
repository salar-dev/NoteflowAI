import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future generateEmbeddings(String content) async {
  String apiKey = dotenv.env['OPENAI_API_KEY']!;
  final url = Uri.parse('https://api.openai.com/v1/embeddings');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    'input': content,
    'model': 'text-embedding-ada-002', // Embedding model
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Parse the response
    final data = jsonDecode(response.body);
    List<double> embedding = List<double>.from(data['data'][0]['embedding']);
    return embedding;
  } else {
    return "Error";
  }
}
