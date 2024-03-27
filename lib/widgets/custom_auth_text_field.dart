import 'package:flutter/material.dart';

class CustomAuthTextField extends StatelessWidget {
  const CustomAuthTextField(
      {super.key,
      required this.controller,
      required this.obscureText,
      required this.icon,
      required this.keyboardType,
      required this.labelText,
      this.suffix,
      this.readOnly});

  final TextEditingController controller;
  final bool obscureText;
  final Widget icon;
  final TextInputType keyboardType;
  final String labelText;
  final Widget? suffix;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 14,
            color: color.secondary,
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            icon: icon,
            suffixIcon: suffix,
          ),
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
