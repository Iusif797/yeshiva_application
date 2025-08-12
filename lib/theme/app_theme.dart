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
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D5BFF)),
    textTheme: GoogleFonts.heeboTextTheme(),
    scaffoldBackgroundColor: const Color(0xFFF6F7FB),
  );

  final baseDark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6D5BFF),
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.heeboTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1116),
  );

  return AppThemePair(light: baseLight, dark: baseDark);
}


