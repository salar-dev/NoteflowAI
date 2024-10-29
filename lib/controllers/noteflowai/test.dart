// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:encrypt/encrypt.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// // Load API keys and other constants from .env
// String supabaseUrl = dotenv.env['PROJECT_URL']!;
// String supabaseAnonKey = dotenv.env['PROJECT_ANON_KEY']!;
// String openaiApiKey = dotenv.env['OPENAI_API_KEY']!;
// String encryptionKey = dotenv.env['ENCRYPTOR_KEY']!;

// // Function to make API call to OpenAI for embedding generation
// Future<List<double>> generateEmbedding(String text) async {
//   final Uri url = Uri.parse('https://api.openai.com/v1/embeddings');
  
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $openaiApiKey',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'model': 'text-embedding-ada-002',
//       'input': text,
//     }),
//   );

//   final data = jsonDecode(response.body);
//   List<dynamic> embedding = data['data'][0]['embedding'];
//   return embedding.map((e) => e.toDouble()).toList();
// }

// // Function to find relevant notes from Supabase
// Future<List<Map<String, dynamic>>> findRelevantNotes(String userId, List<double> questionEmbedding) async {
//   final Uri url = Uri.parse('$supabaseUrl/rest/v1/rpc/search_notes_by_user');
  
//   final response = await http.post(
//     url,
//     headers: {
//       'apikey': supabaseAnonKey,
//       'Authorization': 'Bearer $supabaseAnonKey',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'query_embedding': questionEmbedding,
//       'userid': userId,
//     }),
//   );

//   if (response.statusCode == 200) {
//     return List<Map<String, dynamic>>.from(jsonDecode(response.body));
//   } else {
//     throw Exception('Error fetching relevant notes: ${response.body}');
//   }
// }

// // AES-GCM decryption in Flutter using encrypt package
// String decrypt(String encryptedText) {
//   final parts = encryptedText.split(':');
//   final iv = IV.fromBase64(parts[0]);
//   final cipherText = Encrypted.fromBase64(parts[1]);

//   final key = Key.fromUtf8(encryptionKey.padRight(32));
//   final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
  
//   return encrypter.decrypt(cipherText, iv: iv);
// }

// // Generate answer based on relevant notes using OpenAI API
// Future<String> generateAnswerFromNotes(List<Map<String, dynamic>> notes, String question) async {
//   final String notesContent = notes.map((note) {
//     return 'Title: ${note['title']}\nContent: ${note['noteContent']}\n';
//   }).join('\n');

//   final prompt = '''
//     Based on the following notes, extract the information that directly answers the user's question.
//     If there is no note related to the question, respond with "There is no information in your notes related to your question," and mention the question briefly.
    
//     Notes:
//     $notesContent
    
//     Question: $question
//   ''';

//   final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $openaiApiKey',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'model': 'gpt-4-0125-preview',
//       'messages': [
//         { 'role': 'system', 'content': 'You are a helpful assistant.' },
//         { 'role': 'user', 'content': prompt },
//       ],
//       'max_tokens': 150,
//     }),
//   );

//   final data = jsonDecode(response.body);
//   return data['choices'][0]['message']['content'];
// }

// // Main function to process the question
// Future<void> askQuestion(String userId, String question) async {
//   try {
//     // Step 1: Generate embedding for the question
//     List<double> questionEmbedding = await generateEmbedding(question);

//     // Step 2: Fetch relevant notes from Supabase
//     List<Map<String, dynamic>> relevantNotes = await findRelevantNotes(userId, questionEmbedding);

//     if (relevantNotes.isEmpty) {
//       print('No relevant notes found.');
//       return;
//     }

//     // Step 3: Decrypt the content of the notes
//     relevantNotes = relevantNotes.map((note) {
//       return {
//         ...note,
//         'title': decrypt(note['title']),
//         'noteContent': decrypt(note['noteContent']),
//         'imageTexts': note['imageTexts'] != null ? decrypt(note['imageTexts']) : '',
//       };
//     }).toList();

//     // Step 4: Generate answer based on decrypted notes
//     String answer = await generateAnswerFromNotes(relevantNotes, question);
//     print('Answer: $answer');  
//   } catch (e) {
//     print('Error: $e');
//   }
// }
