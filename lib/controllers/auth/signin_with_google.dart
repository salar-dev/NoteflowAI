import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future signInWithGoogle() async {
  try {
    String? webClientId = dotenv.env['WEB_CLIENT_ID']!;
    String? iosClientId = dotenv.env['IOS_CLIENT_ID']!;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
      scopes: ['email', 'profile'],
      forceCodeForRefreshToken: true,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  } on AuthException catch (e) {
    return e.message;
  } catch (e) {
    if (kDebugMode) {
      print(">>>>>>>>>>>>>>>>>>> $e");
    }
    return e;
  }
}
