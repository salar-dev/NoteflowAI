import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:rive/rive.dart' as rive;
import '../../../utilities/colors.dart';
import '../../screens/aichat/aichat_screen.dart';

class FloatingActionBtnAi extends StatelessWidget {
  const FloatingActionBtnAi({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AichatScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const rive.RiveAnimation.asset(
                "assets/images/animationNoteflowaiBtn.riv",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
