import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  void addMessage(String sender, String content) {
    _messages.insert(0, {
      'sender': sender,
      'content': content,
    });
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
