import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

toastMssg(BuildContext context, String msg, int duration, bool isTop,
    ToastificationType type) {
  toastification.show(
    context: context,
    title: Text(
      msg,
      style: const TextStyle(
        fontSize: 16,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    ),
    autoCloseDuration: Duration(seconds: duration),
    alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
    type: type,
    style: ToastificationStyle.minimal,
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
  );
}
