import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Subscribe to real-time updates for the user
  Stream subscribeToUserUpdates() {
    final userID = _supabase.auth.currentUser!.id;

    return _supabase
        .from("users")
        .stream(primaryKey: ["userID"]).eq('userID', userID);
  }
}
