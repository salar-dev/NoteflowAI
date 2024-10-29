import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/utilities/encryptor.dart';
import 'package:noteflowaiapp/utilities/screen.dart';
import '../../../controllers/note/note_repository.dart';
import '../../../models/note/note.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'note_screen.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key, required this.ascending});

  final bool ascending;

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  final NoteRepository userRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    String local = context.locale.toString().split("_").first;
    timeago.setLocaleMessages(
        local, local == "en" ? timeago.EnMessages() : timeago.ArMessages());
    return Expanded(
      child: StreamBuilder<List<Note>>(
        stream: userRepository.subscribeToNoteUpdates(widget.ascending),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                context.tr("NoNoteAddedYet"),
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index];
              String title = Encryptor().decrypt(note.title);
              String content = Encryptor().decrypt(note.content);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: note),
                      ),
                    ).then((result) {
                      if (result == "delete") {
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                    width: widthScreen(context),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title.length >= 24
                                  ? "${title.substring(0, 24)}..."
                                  : title,
                              style: const TextStyle(
                                color: mainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              timeago.format(
                                note.createdAt,
                                locale:
                                    context.locale.toString().split("_").first,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          content.length >= 100
                              ? "${content.substring(0, 100)}..."
                              : content,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        note.photos.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.photo_library_sharp,
                                        color: mainColor.withOpacity(0.8),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "photosInNote".tr(args: [
                                          note.photos.length.toString()
                                        ]),
                                        style: TextStyle(
                                          color: mainColor.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
