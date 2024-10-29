import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:noteflowaiapp/controllers/note/generate_embeddings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utilities/encryptor.dart';
import '../images/upload_photos.dart';

Future addNote(String title, String noteContent, String imageTexts,
    List<File> photos) async {
  try {
    String userId = Supabase.instance.client.auth.currentUser!.id;
    List<double> embeddingsData = [];
    List<String>? photosUrl;
    await generateEmbeddings("$title - $noteContent - $imageTexts")
        .then((result) {
      if (result != null) {
        embeddingsData = result;
      }
    });

    if (photos.isNotEmpty) {
      Map<String, List<String>> result = await uploadPhotos(photos, userId);
      if (result['failed']!.isNotEmpty) {
        if (kDebugMode) {
          print('\nFailed to upload: ${result['failed']!.join(', ')}');
        }
      }
      photosUrl = result["uploaded"];
    }

    await Supabase.instance.client.from("notes").insert({
      "user_id": userId,
      "title": Encryptor().encrypt(title),
      "noteContent": Encryptor().encrypt(noteContent),
      "imageTexts":
          imageTexts.isNotEmpty ? Encryptor().encrypt(imageTexts) : imageTexts,
      "embedding": embeddingsData,
      "photos": photosUrl,
      "created_at": DateTime.now().toIso8601String(),
    });
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return "Error";
  }
}
