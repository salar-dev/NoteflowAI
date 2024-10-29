import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:noteflowaiapp/models/note/note.dart';

Future generateAnswer(List<Note> notes, String question) async {
  try {
    final String notesContent = notes.map((note) {
      return 'Title: ${note.title}\nContent: ${note.content} ${note.imageTexts}\n';
    }).join('\n');

    final prompt = '''
    Based on the following notes, extract the information that directly answers the user's question.
    If there is no note related to the question, respond with "There is no information in your notes related to your question," and mention the question briefly.
    
    Notes:
    $notesContent
    
    Question: $question
  ''';

    final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']!}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4-0125-preview',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> decodedResponse = jsonDecode(utf8DecodedBody);

      return decodedResponse['choices'][0]['message']['content'];
    } else {
      return "Error";
    }
  } catch (e) {
    return [];
  }
}
