import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/screen.dart';

class NoteTitleTextfield extends StatelessWidget {
  const NoteTitleTextfield({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen(context),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLength: 100,
        style: const TextStyle(
          color: mainColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          label: Text(context.tr("noteTitle")),
          labelStyle: TextStyle(
            color: mainColor.withOpacity(0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.trim() == "") {
            return context.tr("NotetitleCannotBeEmpty");
          }
          return null;
        },
      ),
    );
  }
}
