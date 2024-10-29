import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/controllers/note/update_note.dart';
import 'package:noteflowaiapp/models/note/note.dart';
import 'package:noteflowaiapp/view/widgets/buttons/main_button.dart';
import 'package:toastification/toastification.dart';
import '../../../controllers/note/delete_note.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/encryptor.dart';
import '../../widgets/dialog/yes_no_dialog.dart';
import '../../widgets/fields/note_textfield.dart';
import '../../widgets/note/note_photos.dart';
import '../../widgets/toast/toast_mssg.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, required this.note, this.decrypt = true});

  final Note note;
  final bool decrypt;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  bool isUpdating = false;
  final _formKey = GlobalKey<FormState>();
  Encryptor encryptor = Encryptor();

  @override
  void initState() {
    super.initState();
    noteController.text = widget.decrypt
        ? encryptor.decrypt(widget.note.content)
        : widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(context.tr("theNote")),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: mainColor,
          ),
        ),
        actions: [
          widget.decrypt
              ? IconButton(
                  onPressed: () async {
                    bool? result = await yesNoDialog(
                      context,
                      context.tr("DeleteNote"),
                      context.tr("AreYouSureWantDeleteNote"),
                      context.tr("Delete"),
                      context.tr("Cancel"),
                    );
                    if (result != null && result) {
                      deleteNote(widget.note).then((result) {
                        if (context.mounted) {
                          Navigator.pop(context, "delete");
                          toastMssg(
                              context,
                              context.tr("NoteDeletedSuccessfully"),
                              3,
                              true,
                              ToastificationType.success);
                        }
                      });
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[300],
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          noteFocusNode.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.decrypt
                      ? encryptor.decrypt(widget.note.title)
                      : widget.note.title,
                  style: const TextStyle(
                    color: mainColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          NoteTextfield(
                            controller: noteController,
                            focusNode: noteFocusNode,
                          ),
                          widget.note.photos.isNotEmpty
                              ? noteFocusNode.hasFocus
                                  ? const SizedBox()
                                  : NotePhotos(
                                      photosUrl: widget.note.photos,
                                      isAddScreen: false,
                                    )
                              : const SizedBox(),
                          widget.decrypt
                              ? !isUpdating
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        MainButton(
                                          text: context.tr("editNote"),
                                          onTap: () {
                                            String noteContent =
                                                noteController.text;
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (noteController.text !=
                                                  widget.note.content) {
                                                setState(() {
                                                  isUpdating = false;
                                                });
                                                updateNote(
                                                        widget.note.title,
                                                        noteContent,
                                                        widget.note.photos,
                                                        widget.note.id,
                                                        widget.decrypt)
                                                    .then((result) {
                                                  if (context.mounted) {
                                                    setState(() {
                                                      isUpdating = false;
                                                    });

                                                    if (result != "Error") {
                                                      toastMssg(
                                                          context,
                                                          context.tr(
                                                              "NoteEditSuccessfully"),
                                                          3,
                                                          true,
                                                          ToastificationType
                                                              .success);
                                                    } else {
                                                      toastMssg(
                                                          context,
                                                          context.tr(
                                                              "FailedToEditNote"),
                                                          3,
                                                          true,
                                                          ToastificationType
                                                              .error);
                                                    }
                                                  }
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    )
                                  : const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    )
                              : const SizedBox(),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
