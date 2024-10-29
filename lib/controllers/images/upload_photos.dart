import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

Future<Map<String, List<String>>> uploadPhotos(
    List<File> photos, String userId) async {
  List<String> uploadedPhotosUrl = [];
  List<String> failedPhotos = [];
  var uuid = const Uuid();

  for (var photo in photos) {
    try {
      String photoName = uuid.v4();
      String fileExtension = path.extension(photo.path);

      await Supabase.instance.client.storage.from('notesImages').upload(
            '$userId/$photoName$fileExtension',
            photo,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      uploadedPhotosUrl.add('$userId/$photoName$fileExtension');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to upload $photo: $e');
      }
      failedPhotos.add(photo.path);
    }
  }

  return {
    'uploaded': uploadedPhotosUrl,
    'failed': failedPhotos,
  };
}
