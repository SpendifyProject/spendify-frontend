import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData(){
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ThemeData().colorScheme.copyWith(
      primary: const Color.fromRGBO(0, 102, 255, 1),
      onBackground: const Color.fromRGBO(244, 244, 244, 1),
      background: Colors.white,
      secondary: const Color.fromRGBO(162, 162, 167, 1),
      tertiary: const Color.fromRGBO(235, 10, 36, 1),
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color.fromRGBO(0, 102, 255, 1),
        foregroundColor: Colors.white,
      )
    ),
  );
}