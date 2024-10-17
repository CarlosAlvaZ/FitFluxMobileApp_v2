import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeDataDark(context) => ThemeData.dark().copyWith(
    navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
    textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme.copyWith(
        headlineLarge:
            const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        headlineSmall:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        labelLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        labelMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        labelSmall: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        bodyMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodySmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
        displaySmall:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w200))));
