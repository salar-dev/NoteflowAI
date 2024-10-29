import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/utilities/screen.dart';
import 'package:noteflowaiapp/view/screens/auth/auth_screen.dart';
import 'package:noteflowaiapp/view/screens/home/home_screen.dart';
import 'package:noteflowaiapp/view/widgets/toast/toast_mssg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import '../../../controllers/auth/rememberme.dart';
import '../../../controllers/auth/signin_with_email.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/fields/email_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailFocusNode,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final FocusNode emailFocusNode;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  late bool isEmailValid;
  bool _rememberMe = false;
  bool checkFich = false;

  @override
  void initState() {
    super.initState();
    loadSavedEmail().then((savedEmail) {
      setState(() {
        emailController.text = savedEmail;
        if (savedEmail != "") {
          _rememberMe = true;
          isEmailValid = true;
        } else {
          isEmailValid = false;
        }
        checkFich = true;
      });
    }); // Load saved email if Remember Me was checked
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomeScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          if (mounted) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AuthScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkFich
              ? EmailTextfield(
                  controller: emailController,
                  readOnly: false,
                  isEmailValid: isEmailValid,
                  focusNode: widget.emailFocusNode,
                )
              : const SizedBox(),
          // PasswordTextField(
          //   controller: passController,
          //   readOnly: false,
          //   focusNode: widget.passFocusNode,
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Text(
                    context.tr("RememberMe"),
                    style: TextStyle(
                      fontSize: ipad(context) ? 20 : 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          MainButton(
            text: context.tr("LogIn"),
            onTap: () async {
              if (widget._formKey.currentState!.validate()) {
                saveEmail(emailController.text, _rememberMe);
                signinWithEmail(emailController.text.trim()).then((result) {
                  if (result == "done") {
                    if (context.mounted) {
                      toastMssg(context, context.tr("CheckEmailForLoginLink"),
                          4, true, ToastificationType.success);
                    }
                  } else {
                    if (context.mounted) {
                      toastMssg(
                          context, result, 3, true, ToastificationType.error);
                    }
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
