import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/const/sizing_config.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color.fromRGBO(0, 102, 255, 1),
          onBackground: const Color.fromRGBO(244, 244, 244, 1),
          background: Colors.white,
          secondary: const Color.fromRGBO(162, 162, 167, 1),
          tertiary: const Color.fromRGBO(235, 10, 36, 1),
          onPrimary: const Color.fromRGBO(30, 30, 45, 1),
          onSecondary: const Color.fromRGBO(112, 112, 112, 1),
          onTertiary: const Color.fromRGBO(31, 170, 71, 1),
        ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor:
            MaterialStateProperty.all(const Color.fromRGBO(0, 102, 255, 1)),
        foregroundColor:
            MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        fixedSize: MaterialStateProperty.all(
          Size(
            horizontalConverter(context, 335),
            verticalConverter(context, 56),
          ),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: const Color.fromRGBO(0, 102, 255, 1),
        selectedForegroundColor: Colors.white,
        disabledBackgroundColor: Colors.white,
        disabledForegroundColor: const Color.fromRGBO(30, 30, 45, 1),
        foregroundColor: const Color.fromRGBO(30, 30, 45, 1),
      ),
    ),
  );
}