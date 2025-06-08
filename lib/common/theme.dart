import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
    useMaterial3: true,

    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.yellow.shade700,
      primary: Colors.yellow.shade700,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow.shade700),
      displayMedium: GoogleFonts.lato(
          fontWeight: FontWeight.bold, color: Colors.yellow.shade700),
      displaySmall: GoogleFonts.lato(
          fontWeight: FontWeight.bold, color: Colors.yellow.shade700),
      titleLarge: GoogleFonts.oswald(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      titleMedium: GoogleFonts.oswald(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      titleSmall: GoogleFonts.oswald(
          fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 15),
    ));
