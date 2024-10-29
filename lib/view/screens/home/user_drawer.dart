import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/view/screens/auth/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/user/userRepository.dart';
import '../../../controllers/user/user_data.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';
import '../../widgets/local/local_widget.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final supabase = Supabase.instance.client;
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? email = supabase.auth.currentUser!.email;
    return Drawer(
      shadowColor: Colors.transparent,
      width: ipad(context)
          ? widthScreen(context) - 250
          : widthScreen(context) - 100,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.7),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          LocalWidget(),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Image.asset(
                        "assets/images/NoteflowAI_white.png",
                        width: widthScreen(context) * 0.40,
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: widthScreen(context) * 0.30,
                        height: widthScreen(context) * 0.30,
                        decoration: BoxDecoration(
                          color: mainWhiteColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(200),
                          border: Border.all(color: secondaryColor, width: 2),
                        ),
                        child: userAvatarUrl() == null
                            ? Icon(
                                Icons.person,
                                color: mainColor,
                                size: widthScreen(context) * 0.15,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.network(
                                  userAvatarUrl()!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      userName() == null
                          ? const SizedBox()
                          : Text(
                              userName()!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mainWhiteColor,
                                fontSize: ipad(context) ? 20 : 16,
                              ),
                            ),
                      email == null
                          ? const SizedBox()
                          : Text(
                              email,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mainWhiteColor,
                                fontSize: ipad(context) ? 18 : 14,
                              ),
                            ),
                      const SizedBox(height: 25),
                      // StreamBuilder<dynamic>(
                      //     stream: userRepository.subscribeToUserUpdates(),
                      //     builder: (context, snapshot) {
                      //       return Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 5, horizontal: 10),
                      //         width: widthScreen(context),
                      //         height: 55,
                      //         decoration: BoxDecoration(
                      //           color: mainWhiteColor,
                      //           borderRadius: BorderRadius.circular(100),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               context.tr("NoteflowAIMessagesAvailable"),
                      //               style: const TextStyle(
                      //                 color: mainColor,
                      //                 fontSize: 16,
                      //               ),
                      //             ),
                      //             Container(
                      //               padding: const EdgeInsets.all(10),
                      //               decoration: BoxDecoration(
                      //                 color: mainColor,
                      //                 borderRadius: BorderRadius.circular(100),
                      //               ),
                      //               child: Center(
                      //                 child: snapshot.connectionState ==
                      //                         ConnectionState.waiting
                      //                     ? const CircularProgressIndicator
                      //                         .adaptive()
                      //                     : Text(
                      //                         snapshot.data[0]
                      //                                 ["messagesAvailable"]
                      //                             .toString(),
                      //                         style: const TextStyle(
                      //                           color: mainWhiteColor,
                      //                           fontSize: 16,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     }),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Supabase.instance.client.auth.signOut();
                        },
                        child: Text(
                          context.tr("SignOut"),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
      ),
    );
  }
}
