import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future signinWithEmail(String email) async {
  try {
    await Supabase.instance.client.auth.signInWithOtp(
      email: email,
      emailRedirectTo:
          kIsWeb ? null : 'io.supabase.notrflowai://login-callback/',
    );
    return "done";
  } on AuthException catch (e) {
    return e.message;
  } catch (e) {
    return "problemSendingVerificationLink".tr();
  }
}
