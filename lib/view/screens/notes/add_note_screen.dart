import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/utilities/colors.dart';
import 'package:noteflowaiapp/view/widgets/buttons/main_button.dart';
import 'package:noteflowaiapp/view/widgets/toast/toast_mssg.dart';
import 'package:toastification/toastification.dart';
import '../../../controllers/images/capture_photo.dart';
import '../../../controllers/images/text_recognition_image.dart';
import '../../../controllers/note/add_note.dart';
import '../../widgets/fields/note_textfield.dart';
import '../../widgets/fields/note_title_textfield.dart';
import '../../widgets/note/note_photos.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  List<File> photos = [];
  String textReco = "";
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(context.tr("AddNote")),
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
          IconButton(
            onPressed: () {
              if (photos.length >= 3) {
                toastMssg(context, "YouCanAddMaximumPhotos".tr(args: ["3"]), 3,
                    true, ToastificationType.warning);
              } else {
                capturePhoto().then((result) {
                  if (result != null) {
                    photos.add(result);
                    textRecognitionImage(photos, null).then((result) {
                      textReco = result;
                    });
                    setState(() {});
                  }
                });
              }
            },
            icon: const Icon(
              Icons.photo_camera_outlined,
              color: mainColor,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          noteFocusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  NoteTitleTextfield(controller: titleController),
                  const SizedBox(height: 10),
                  NoteTextfield(
                    controller: noteController,
                    focusNode: noteFocusNode,
                  ),
                  photos.isNotEmpty
                      ? noteFocusNode.hasFocus
                          ? const SizedBox()
                          : NotePhotos(
                              photos: photos,
                              onTextRecoUpdated: (newTextReco) {
                                textReco = newTextReco;
                              },
                              isAddScreen: true,
                            )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  isUploading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : MainButton(
                          text: context.tr("AddNote"),
                          onTap: () {
                            noteFocusNode.unfocus();
                            if (_formKey.currentState!.validate()) {
                              String title = titleController.text;
                              String noteContent = noteController.text;
                              setState(() {
                                isUploading = true;
                              });
                              addNote(title, noteContent, textReco, photos)
                                  .then((result) {
                                if (context.mounted) {
                                  setState(() {
                                    isUploading = false;
                                  });

                                  if (result != "Error") {
                                    Navigator.pop(context);
                                    toastMssg(
                                        context,
                                        context.tr("NoteAddSuccessfully"),
                                        3,
                                        true,
                                        ToastificationType.success);
                                  } else {
                                    toastMssg(
                                        context,
                                        context.tr("FailedToAddNote"),
                                        3,
                                        true,
                                        ToastificationType.error);
                                  }
                                }
                              });
                            }
                          },
                        ),
                  const SizedBox(height: 15),
                ],
              )),
        ),
      ),
    );
  }
}
