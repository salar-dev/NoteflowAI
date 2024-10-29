import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/controllers/auth/signin_with_apple.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/utilities/screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/auth/signin_with_google.dart';
import '../../widgets/background/main_background.dart';
import '../../widgets/buttons/login_with_button.dart';
import '../../widgets/local/local_widget.dart';
import '../home/home_screen.dart';
import 'login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFocus = false;
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          isFocus = true;
        });
      } else {
        setState(() {
          isFocus = false;
        });
      }
    });

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MainBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: isFocus
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    isFocus
                        ? const SizedBox()
                        : Column(
                            children: [
                              const Row(
                                children: [
                                  LocalWidget(),
                                ],
                              ),
                              const SizedBox(height: 90),
                              Image.asset(
                                "assets/images/NoteflowAI_white.png",
                                width: widthScreen(context) * 0.6,
                              ),
                            ],
                          ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: widthScreen(context),
                          decoration: BoxDecoration(
                            color: mainWhiteColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                LoginForm(
                                  formKey: _formKey,
                                  emailFocusNode: emailFocusNode,
                                ),
                                const SizedBox(height: 8),
                                LoginWithButton(
                                  text: context.tr("LoginWithGoogle"),
                                  image: "assets/images/google.png",
                                  color: const Color(0xFF367BF4),
                                  onTap: () {
                                    signInWithGoogle();
                                  },
                                ),
                                Platform.isIOS
                                    ? Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          LoginWithButton(
                                            text: context.tr("LoginWithApple"),
                                            image: "assets/images/apple.png",
                                            color: const Color(0xFF020202),
                                            onTap: () {
                                              signInWithApple();
                                            },
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
