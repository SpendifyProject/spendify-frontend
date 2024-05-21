import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/const/sizing_config.dart';

ThemeData darkThemeData(BuildContext context){
  return ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(22, 22, 34, 1),
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ThemeData().colorScheme.copyWith(
      primary: const Color.fromRGBO(0, 102, 255, 1),
      onPrimary: Colors.white,
      onBackground: const Color.fromRGBO(30, 30, 45, 1),
      background: const Color.fromRGBO(22, 22, 34, 1),
      onSecondary: const Color.fromRGBO(139, 139, 148, 1),
      secondary: const Color.fromRGBO(162, 162, 167, 1),
      tertiary: const Color.fromRGBO(235, 10, 36, 1),
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
  );
}