import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:spendify/const/theme.dart';
import 'package:spendify/screens/onboarding/onboarding_1.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendify',
      theme: themeData(),
      debugShowCheckedModeBanner: false,
      home: const Onboarding1(),
    );
  }
}
