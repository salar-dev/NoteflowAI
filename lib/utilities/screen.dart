import 'package:flutter/material.dart';

double widthScreen(context) {
  return MediaQuery.of(context).size.width;
}

double heightScreen(context) {
  return MediaQuery.of(context).size.height;
}

bool ipad(context) {
  return widthScreen(context) >= 600;
}
