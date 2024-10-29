import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class NoteTextfield extends StatefulWidget {
  const NoteTextfield(
      {super.key, required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<NoteTextfield> createState() => _NoteTextfieldState();
}

class _NoteTextfieldState extends State<NoteTextfield> {
  TextAlign textAlign = TextAlign.left;
  @override
  void initState() {
    super.initState();
    _onTextChanged();
    widget.controller.addListener(_onTextChanged);
  }

  bool _isArabic(String char) {
    return RegExp(r'^[\u0600-\u06FF]').hasMatch(char);
  }

  void _onTextChanged() {
    List<String> lines = widget.controller.text.split('\n');

    for (String line in lines) {
      if (line.isNotEmpty && _isArabic(line[0])) {
        setState(() {
          textAlign = TextAlign.right;
        });
      } else {
        setState(() {
          textAlign = TextAlign.left;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 55,
        width: widthScreen(context),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: textAlign,
          style: const TextStyle(
            color: mainColor,
            fontSize: 16,
          ),
          maxLength: 2000,
          maxLines: 100,
          decoration: InputDecoration(
            hintText: context.tr("WriteNote"),
            hintStyle: TextStyle(
              color: mainColor.withOpacity(0.5),
            ),
            labelStyle: TextStyle(
              color: mainColor.withOpacity(0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: mainColor.withOpacity(0.3), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.trim() == "") {
              return context.tr("NoteCannotBeLeftBlank");
            }
            return null;
          },
        ),
      ),
    );
  }
}
