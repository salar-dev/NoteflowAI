import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class LoginWithButton extends StatelessWidget {
  final String text;
  final Color color;
  final String image;
  final void Function()? onTap;

  const LoginWithButton({
    super.key,
    required this.text,
    required this.color,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context),
      height: ipad(context) ? 65 : 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: MaterialButton(
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: ipad(context) ? 40 : 35,
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: mainWhiteColor,
                  fontSize: ipad(context) ? 20 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
