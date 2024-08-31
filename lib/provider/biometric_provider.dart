import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool isBiometricEnabled = false;

  BiometricProvider() {
    loadBiometrics();
  }

  Future<bool> loadBiometrics() async {
    _prefs = await SharedPreferences.getInstance();
    isBiometricEnabled = _prefs.getBool('isBiometricEnabled') ?? false;
    print(isBiometricEnabled);
    notifyListeners();
    return isBiometricEnabled;
  }

  bool get biometricEnabled => isBiometricEnabled;

  Future<void> switchBiometricPrefs() async {
    isBiometricEnabled = !isBiometricEnabled;
    await _prefs.setBool('isBiometricEnabled', isBiometricEnabled);
    notifyListeners();
  }
}
