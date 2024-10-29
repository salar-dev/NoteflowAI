import 'package:shared_preferences/shared_preferences.dart';

Future<String> loadSavedEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedEmail = prefs.getString('savedEmail');
  bool? rememberMe = prefs.getBool('rememberMe');

  if (savedEmail != null && rememberMe == true) {
    return savedEmail;
  } else {
    return "";
  }
}

// Save or remove email from SharedPreferences
Future<void> saveEmail(String email, bool rememberMe) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (rememberMe) {
    await prefs.setString('savedEmail', email);
    await prefs.setBool('rememberMe', true);
  } else {
    await prefs.remove('savedEmail');
    await prefs.setBool('rememberMe', false);
  }
}
