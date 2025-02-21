import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  // Define your custom fonts
  static const FontWeight bold = FontWeight.bold; // Añadir esta línea
  static const String primaryFont = 'BalooDa';
  static const String secondaryFont = 'AnyBody';
  static const String accentFont = 'YourAccentFont';

  // Define text styles using the custom fonts
  static const TextStyle headline = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16.0,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: accentFont,
    fontSize: 12.0,
  );
}