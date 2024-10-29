import 'package:flutter/foundation.dart';
import 'package:noteflowaiapp/models/note/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future deleteNote(Note note) async {
  try {
    final supabase = Supabase.instance.client;
    if (note.photos.isNotEmpty) {
      await supabase.storage.from('notesImages').remove(note.photos);
    }
    await supabase.from('notes').delete().eq('id', note.id);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
