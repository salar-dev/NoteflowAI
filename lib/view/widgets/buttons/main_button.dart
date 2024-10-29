import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class MainButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MainButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: widthScreen(context),
      height: ipad(context) ? 65 : 55,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: ipad(context) ? 20 : 16,
              color: mainWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
