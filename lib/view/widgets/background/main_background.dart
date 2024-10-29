import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class MainBackground extends StatelessWidget {
  const MainBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context),
      height: heightScreen(context),
      color: mainColor,
      child: Column(
        children: [
          Image.asset(
            "assets/images/background_lines.png",
            width: widthScreen(context),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
