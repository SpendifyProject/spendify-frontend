import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message) {
  final color = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: color.primary,
    ),
  );
}
