import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/images/text_recognition_image.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class NotePhotos extends StatefulWidget {
  const NotePhotos(
      {super.key,
      this.photos,
      this.onTextRecoUpdated,
      required this.isAddScreen,
      this.photosUrl});

  final List<File>? photos;
  final List<String>? photosUrl;
  final Function(String)? onTextRecoUpdated;
  final bool isAddScreen;

  @override
  State<NotePhotos> createState() => _NotePhotosState();
}

class _NotePhotosState extends State<NotePhotos> {
  List<String> photoUrls = [];
  Future downloadPhotos() async {
    if (widget.photosUrl != null) {
      try {
        for (String photo in widget.photosUrl!) {
          final response = await Supabase.instance.client.storage
              .from('notesImages')
              .createSignedUrl(photo.replaceFirst("notesImages/", ""), 60 * 60);
          photoUrls.add(response);
        }
        setState(() {});
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    downloadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: widthScreen(context),
          height: 85,
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount:
                widget.isAddScreen ? widget.photos!.length : photoUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    MultiImageProvider multiImageProvider;
                    if (widget.isAddScreen) {
                      multiImageProvider = MultiImageProvider(
                        widget.photos!
                            .map((image) => FileImage(image))
                            .toList(),
                        initialIndex: index,
                      );
                    } else {
                      multiImageProvider = MultiImageProvider(
                        photoUrls.map((image) => NetworkImage(image)).toList(),
                        initialIndex: index,
                      );
                    }

                    showImageViewerPager(
                      context,
                      multiImageProvider,
                      useSafeArea: true,
                      doubleTapZoomable: true,
                      infinitelyScrollable: true,
                      swipeDismissible: true,
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: widget.isAddScreen
                              ? Image.file(
                                  widget.photos![index],
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: photoUrls[index],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      widget.isAddScreen
                          ? Positioned(
                              top: -18,
                              left: -20,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.photos!.removeAt(index);
                                  });
                                  textRecognitionImage(widget.photos!, null)
                                      .then((result) {
                                    widget.onTextRecoUpdated!(result);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
