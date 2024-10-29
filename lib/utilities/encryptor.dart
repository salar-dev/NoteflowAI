import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Encryptor {
  final String encryptorKey = dotenv.env['ENCRYPTOR_KEY']!;

  // AES-GCM Encryption
  String encrypt(String text) {
    final key = Key.fromUtf8(encryptorKey.padRight(32)); // Ensure 32-byte key
    final iv = IV.fromLength(12); // 12-byte IV for AES-GCM
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(text, iv: iv);
    final ivBase64 = base64Encode(iv.bytes);
    return "$ivBase64:${encrypted.base64}";
  }

  // AES-GCM Decryption
  String decrypt(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      final iv = IV.fromBase64(parts[0]); // Extract IV from the encrypted text
      final encrypted =
          Encrypted.fromBase64(parts[1]); // Extract encrypted data

      final key = Key.fromUtf8(encryptorKey.padRight(32)); // Ensure 32-byte key
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      return encrypter.decrypt(encrypted, iv: iv); // Decrypt with AES-GCM
    } catch (e) {
      throw Exception('InvalidCipherTextException: Failed to decrypt');
    }
  }
}
