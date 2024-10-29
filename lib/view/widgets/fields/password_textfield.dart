import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utilities/colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onTap;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final FocusNode focusNode;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.validator,
    required this.readOnly,
    required this.focusNode,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText, // Toggles obscure text on and off
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: context.tr("Password"),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: mainColor,
        ),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: mainColor,
                ),
                onPressed: () {
                  _obscureText = !_obscureText;
                  setState(() {});
                },
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
          return "PasswordCannotBeEmpty".tr();
        }
        if (value.length < 8) {
          return "EnterValidPassword".tr();
        }
        return null;
      },
      readOnly: widget.readOnly,
      onTap: widget.onTap,
    );
  }
}
