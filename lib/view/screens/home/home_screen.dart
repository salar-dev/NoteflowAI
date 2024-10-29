import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/view/screens/notes/add_note_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/user/check_user.dart';
import '../../../controllers/user/userRepository.dart';
import '../../widgets/appbar/homescreen_appbar.dart';
import '../../widgets/buttons/floating_action_btn_ai.dart';
import '../notes/all_notes.dart';
import 'user_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final supabase = Supabase.instance.client;
  bool ascending = false;

  @override
  void initState() {
    super.initState();
    createUser();
    UserRepository().subscribeToUserUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomescreenAppbar(
        globalKey: _scaffoldKey,
      ),
      drawer: const UserDrawer(),
      floatingActionButton: const FloatingActionBtnAi(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr("MyNotes"),
                  style: const TextStyle(
                    color: greyColor,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddNoteScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        color: mainColor,
                        size: 28,
                      ),
                      tooltip: context.tr("AddNote"),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ascending = !ascending;
                        });
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: mainColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            AllNotes(ascending: ascending),
          ],
        ),
      ),
    );
  }
}
