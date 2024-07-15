import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool isDarkThemeEnabled = false;

  ThemeProvider() {
    _loadTheme();
  }

  _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkThemeEnabled = _prefs.getBool('isDarkThemeEnabled') ?? false;
    notifyListeners();
  }

  bool get darkTheme => isDarkThemeEnabled;

  void switchTheme() async {
    isDarkThemeEnabled = !isDarkThemeEnabled;
    await _prefs.setBool('isDarkThemeEnabled', isDarkThemeEnabled);
    notifyListeners();
  }
}
