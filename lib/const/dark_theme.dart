import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(22, 22, 34, 1),
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color.fromRGBO(0, 102, 255, 1),
          onPrimary: Colors.white,
          onSurface: const Color.fromRGBO(30, 30, 45, 1),
          surface: const Color.fromRGBO(22, 22, 34, 1),
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
        elevation: WidgetStateProperty.all(0),
        backgroundColor:
            WidgetStateProperty.all(const Color.fromRGBO(0, 102, 255, 1)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(
            335.w,
            56.h,
          ),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: const Color.fromRGBO(0, 102, 255, 1),
        selectedForegroundColor: Colors.white,
        disabledBackgroundColor: const Color.fromRGBO(30, 30, 45, 1),
        disabledForegroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
