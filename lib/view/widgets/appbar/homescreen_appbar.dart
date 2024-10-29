import 'package:flutter/material.dart';
import '../../../controllers/user/user_data.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class HomescreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomescreenAppbar({super.key, required this.globalKey});

  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: Image.asset(
        "assets/images/NoteflowAI_maincolor.png",
        width: ipad(context)
            ? widthScreen(context) * 0.25
            : widthScreen(context) * 0.35,
      ),
      centerTitle: true,
      leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            globalKey.currentState?.openDrawer();
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: secondaryColor, width: 2),
            ),
            child: userAvatarUrl() == null
                ? const Icon(
                    Icons.person,
                    color: mainWhiteColor,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      userAvatarUrl()!,
                      width: 40,
                    ),
                  ),
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
