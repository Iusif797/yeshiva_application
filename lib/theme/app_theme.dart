import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemePair {
  final ThemeData light;
  final ThemeData dark;
  const AppThemePair({required this.light, required this.dark});
}

AppThemePair buildAppTheme() {
  final baseLight = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED), brightness: Brightness.light),
    textTheme: GoogleFonts.heeboTextTheme(),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
    cardTheme: CardTheme(color: Colors.white, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    shadowColor: const Color.fromRGBO(16, 24, 40, 0.06),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
  );

  final baseDark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED), brightness: Brightness.dark),
    textTheme: GoogleFonts.heeboTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    scaffoldBackgroundColor: const Color(0xFF0B0F14),
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Color(0xFF0B0F14), foregroundColor: Colors.white),
    cardTheme: CardTheme(color: const Color(0xFF121826), elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    shadowColor: const Color.fromRGBO(0, 0, 0, 0.4),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFF111827), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
  );

  return AppThemePair(light: baseLight, dark: baseDark);
}


