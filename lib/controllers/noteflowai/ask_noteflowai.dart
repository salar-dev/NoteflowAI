import 'package:flutter/foundation.dart';
import '../../models/note/note.dart';
import '../../utilities/encryptor.dart';
import '../note/generate_embeddings.dart';
import 'generate_answer.dart';
import 'relevant_notes.dart';

Future askNoteflowAI(String question) async {
  try {
    List<double> questionEmbeddings = await generateEmbeddings(question);

    List<Map<String, dynamic>> relevantNote =
        await getRelevantNote(questionEmbeddings);

    List<Note> relevantNotes = relevantNote.map((note) {
      return Note(
        id: note['id'],
        userId: note['user_id'] ?? '', // Provide a default value if null
        title: note['title'] != null ? Encryptor().decrypt(note['title']) : '',
        content: note['notecontent'] != null
            ? Encryptor().decrypt(note['notecontent'])
            : '',
        createdAt: note['created_at'] != null
            ? DateTime.parse(note['created_at'])
            : DateTime.now(),
        photos: List<String>.from(note['photos'] ?? []),
        imageTexts: note['imagetexts'] != null && note['imagetexts'] != ''
            ? Encryptor().decrypt(note['imagetexts'])
            : '',
      );
    }).toList();

    String answer = await generateAnswer(relevantNotes, question);

    return [answer, relevantNotes];
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    return "Error";
  }
}
