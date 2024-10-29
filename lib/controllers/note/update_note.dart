import 'package:flutter/foundation.dart';
import 'package:noteflowaiapp/controllers/note/generate_embeddings.dart';
import 'package:noteflowaiapp/utilities/encryptor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../images/text_recognition_image.dart';

Future updateNote(String title, String noteContent, List<String> photos,
    int noteId, bool decrypt) async {
  Encryptor encryptor = Encryptor();
  try {
    List<double> embeddingsData = [];
    String textReco = "";
    textRecognitionImage(null, photos).then((result) {
      textReco = result;
    });
    await generateEmbeddings(decrypt
            ? "${encryptor.decrypt(title)} - $noteContent - $textReco"
            : "$title - $noteContent - $textReco")
        .then((result) {
      if (result != null) {
        embeddingsData = result;
      }
    });

    await Supabase.instance.client.from("notes").update({
      "noteContent": encryptor.encrypt(noteContent),
      "embedding": embeddingsData,
      "created_at": DateTime.now().toIso8601String(),
    }).eq("id", noteId);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return "Error";
  }
}
