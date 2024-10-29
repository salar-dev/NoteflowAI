import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/utilities/screen.dart';
import 'package:noteflowaiapp/view/screens/auth/auth_screen.dart';
import 'package:noteflowaiapp/view/screens/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future authState() async {
    await Future.delayed(const Duration(seconds: 2));
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.initialSession:
          if (session == null) {
            if (mounted) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AuthScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            if (mounted) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          }

          break;
        case AuthChangeEvent.signedIn:
          // handle signed in
          if (session == null) {
            if (mounted) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AuthScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            if (mounted) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            }
          }
          break;

        case AuthChangeEvent.signedOut:
          if (mounted) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AuthScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }

        // handle signed out
        case AuthChangeEvent.passwordRecovery:
        // handle password recovery
        case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        case AuthChangeEvent.userUpdated:
        // handle user updated
        case AuthChangeEvent.mfaChallengeVerified:
        // handle mfa challenge verified
        // ignore: deprecated_member_use
        case AuthChangeEvent.userDeleted:
      }
    });
  }

  @override
  void initState() {
    super.initState();

    authState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Image.asset(
                "assets/images/noteflowai.png",
                width: widthScreen(context) * 0.6,
              ),
              LoadingAnimationWidget.staggeredDotsWave(
                color: mainColor,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
