import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<File> convertUint8ListToFile(Uint8List bytes, String fileName) async {
  final Directory tempDir = await getApplicationDocumentsDirectory();
  final String filePath = join(tempDir.path, fileName.replaceFirst("/", ""));
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  return file;
}

Future textRecognitionImage(
    List<File>? localImages, List<String>? imageUrls) async {
  String texts = "";
  try {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Process local images
    if (localImages != null) {
      for (var image in localImages) {
        final inputImage = InputImage.fromFilePath(image.path);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        texts += recognizedText.text;
      }
    }

    // Process network images
    if (imageUrls != null) {
      for (var imageUrl in imageUrls) {
        final Uint8List file = await Supabase.instance.client.storage
            .from('notesImages')
            .download(imageUrl.replaceFirst("notesImages/", ""));
        final imagefile = await convertUint8ListToFile(
            file, imageUrl.replaceFirst("notesImages/", ""));
        final inputImage = InputImage.fromFile(imagefile);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        texts += recognizedText.text;
      }
    }

    if (kDebugMode) {
      print(">>>>>>>> Texts <<<<<<<<");
      print(texts);
    }

    return texts;
  } catch (e) {
    return e;
  }
}
