import 'package:flutter/material.dart';

import '../models/note/note.dart';

class RelevantNotesProvider with ChangeNotifier {
  List<Note> _relevantNotes = [];

  List<Note> get relevantNotes => _relevantNotes;

  void addRelevantNote(Note note) {
    _relevantNotes.add(note);
    notifyListeners();
  }

  void setRelevantNotes(List<Note> notes) {
    _relevantNotes = notes;
    notifyListeners();
  }

  void clearRelevantNotes() {
    _relevantNotes.clear();
    notifyListeners();
  }
}
