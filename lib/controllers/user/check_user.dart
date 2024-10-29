import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_data.dart';

Future createUser() async {
  final supabase = Supabase.instance.client;
  final user = await supabase
      .from("users")
      .select("userID")
      .eq("userID", supabase.auth.currentUser!.id);

  if (user.isEmpty) {
    await Supabase.instance.client.from("users").insert({
      "userID": Supabase.instance.client.auth.currentUser!.id,
      "email": Supabase.instance.client.auth.currentUser!.email,
      "name": userName(),
      "messagesAvailable": 15,
    });
  }
}
