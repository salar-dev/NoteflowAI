import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:noteflowaiapp/controllers/noteflowai/ask_noteflowai.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/view/widgets/background/main_background.dart';
import 'package:noteflowaiapp/view/widgets/toast/toast_mssg.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../../provider/message_provider.dart';
import '../../../provider/relevant_notes_provider.dart';
import '../../../utilities/screen.dart';
import '../notes/note_screen.dart';

class AichatScreen extends StatefulWidget {
  const AichatScreen({super.key});

  @override
  State<AichatScreen> createState() => _AichatScreenState();
}

class _AichatScreenState extends State<AichatScreen> {
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  bool isThinks = false;

  Future sendMessage(String message) async {
    setState(() {
      isThinks = true;
    });
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);

    final relevantNotesProvider =
        Provider.of<RelevantNotesProvider>(context, listen: false);

    messageProvider.addMessage('user', message);

    askNoteflowAI(message).then((result) {
      setState(() {
        isThinks = false;
      });
      if (result != "Error") {
        relevantNotesProvider.clearRelevantNotes();
        messageProvider.addMessage('NoteflowAI', result[0]);
        relevantNotesProvider.setRelevantNotes(result[1]);
      } else {
        if (mounted) {
          toastMssg(context, context.tr("somethingWentWrong"), 4, true,
              ToastificationType.error);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final relevantNotesProvider = Provider.of<RelevantNotesProvider>(context);
    return GestureDetector(
      onTap: () {
        messageFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: mainColor,
        body: Stack(
          children: [
            const MainBackground(),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: mainWhiteColor,
                      ),
                    ),
                    title: Image.asset(
                      "assets/images/NoteflowAI_white.png",
                      width: ipad(context)
                          ? widthScreen(context) * 0.25
                          : widthScreen(context) * 0.35,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                        width: widthScreen(context),
                        child: messageProvider.messages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/ai.png",
                                      width: 65,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Ask a question\nabout your Notes...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: mainWhiteColor.withOpacity(0.6),
                                        fontSize: widthScreen(context) * 0.06,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                reverse: true,
                                itemCount: messageProvider.messages.length,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final isUserMessage = messageProvider
                                          .messages[index]["sender"] ==
                                      "user";
                                  return Align(
                                    alignment: isUserMessage
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isUserMessage
                                              ? mainWhiteColor
                                              : secondaryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(18),
                                            topRight: const Radius.circular(18),
                                            bottomLeft: isUserMessage
                                                ? const Radius.circular(18)
                                                : const Radius.circular(0),
                                            bottomRight: isUserMessage
                                                ? const Radius.circular(0)
                                                : const Radius.circular(18),
                                          ),
                                        ),
                                        child: SelectableText(
                                          messageProvider.messages[index]
                                              ["content"]!,
                                          textAlign: isUserMessage
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          style: TextStyle(
                                            fontSize: ipad(context) ? 20 : 18,
                                            color: isUserMessage
                                                ? Colors.black
                                                : mainWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                  ),
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: widthScreen(context),
                      child: Column(
                        children: [
                          relevantNotesProvider.relevantNotes.isNotEmpty
                              ? SizedBox(
                                  width: widthScreen(context),
                                  height: ipad(context) ? 65 : 55,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: relevantNotesProvider
                                          .relevantNotes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String title = relevantNotesProvider
                                            .relevantNotes[index].title;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoteScreen(
                                                    note: relevantNotesProvider
                                                        .relevantNotes[index],
                                                    decrypt: false,
                                                  ),
                                                ),
                                              ).then((result) {
                                                if (result == "delete") {
                                                  setState(() {});
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: mainWhiteColor
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.note_alt_outlined,
                                                    color: mainColor,
                                                    size:
                                                        ipad(context) ? 28 : 24,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    title.length >= 18
                                                        ? "${title.substring(0, 18)}..."
                                                        : title,
                                                    style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: ipad(context)
                                                          ? 18
                                                          : 14,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              cursorColor: mainWhiteColor,
                              controller: messageController,
                              focusNode: messageFocusNode,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(
                                color: mainWhiteColor,
                                fontSize: 18,
                              ),
                              minLines: 1,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Message NoteflowAI",
                                hintStyle: TextStyle(
                                  color: mainWhiteColor.withOpacity(0.6),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: mainWhiteColor.withOpacity(0.6),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: mainWhiteColor, width: 2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                suffixIcon: isThinks
                                    ? LoadingAnimationWidget.fourRotatingDots(
                                        color: Colors.white,
                                        size: ipad(context) ? 28 : 24,
                                      )
                                    : IconButton(
                                        icon: Image.asset(
                                          "assets/images/send_white.png",
                                          width: ipad(context) ? 28 : 24,
                                        ),
                                        onPressed: () {
                                          if (messageController.text
                                              .trim()
                                              .isNotEmpty) {
                                            sendMessage(messageController.text);
                                            messageController.clear();
                                          }
                                        },
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
