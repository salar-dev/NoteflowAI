import 'package:flutter/material.dart';
import '../utilities/colors.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Madani',
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: mainColor, // Use primary for AppBar, buttons, etc.
    secondary: secondaryColor, // Secondary color
  ),
  scaffoldBackgroundColor: mainWhiteColor,
  appBarTheme: const AppBarTheme(
    color: mainWhiteColor,
    titleTextStyle:
        TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black), // Update to headlineLarge
    bodyLarge:
        TextStyle(fontSize: 16.0, color: Colors.black), // Update to bodyLarge
    bodyMedium:
        TextStyle(fontSize: 14.0, color: Colors.black), // Update to bodyMedium
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: mainColor, // Button background color
      foregroundColor: Colors.white, // Text color on the button
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.grey),
      textStyle: WidgetStateProperty.all<TextStyle?>(
        const TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  ),
);
