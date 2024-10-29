import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteflowaiapp/utilities/screen.dart';
import '../../../utilities/colors.dart';

class EmailTextfield extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onTap;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final bool isEmailValid;
  final FocusNode focusNode;
  const EmailTextfield({
    super.key,
    required this.controller,
    this.onTap,
    this.validator,
    required this.readOnly,
    required this.isEmailValid,
    required this.focusNode,
  });

  @override
  State<EmailTextfield> createState() => _EmailTextfieldState();
}

class _EmailTextfieldState extends State<EmailTextfield> {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _isEmailValid = widget.isEmailValid;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: TextStyle(
        fontSize: ipad(context) ? 20 : 16,
      ),
      onChanged: (text) {
        // Validate email using the regular expression
        setState(() {
          _isEmailValid = emailRegex.hasMatch(text);
        });
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: context.tr("email"),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: mainColor,
          size: ipad(context) ? 28 : 22,
        ),
        suffixIcon: _isEmailValid
            ? const Icon(
                Icons.check_circle,
                color: mainColor,
              )
            : const SizedBox(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.tr("EmailCannotBeEmpty");
        }
        if (!_isEmailValid) {
          return context.tr("EnterValidEmail");
        }
        return null;
      },
      readOnly: widget.readOnly,
      onTap: widget.onTap,
    );
  }
}
