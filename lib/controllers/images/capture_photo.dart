import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future capturePhoto() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (photo == null) return null;
    File? img = File(photo.path);
    return img;
  } on PlatformException catch (e) {
    return e.message;
  }
}
