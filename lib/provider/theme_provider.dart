import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  bool isDarkThemeEnabled = false;

  bool get darkTheme => isDarkThemeEnabled;

  void switchTheme(){
    isDarkThemeEnabled = !isDarkThemeEnabled;
    notifyListeners();
  }
}