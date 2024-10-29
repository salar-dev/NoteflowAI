import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/note/note.dart';

class NoteRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<Note>> subscribeToNoteUpdates(bool ascending) {
    final userID = _supabase.auth.currentUser!.id;

    return _supabase
        .from("notes")
        .stream(primaryKey: ["id"])
        .eq('user_id', userID)
        .order("created_at", ascending: ascending)
        .map((data) {
          return data.map<Note>((map) => Note.fromMap(map)).toList();
        });
  }
}
