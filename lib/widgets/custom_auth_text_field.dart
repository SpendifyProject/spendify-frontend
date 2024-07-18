import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAuthTextField extends StatelessWidget {
  const CustomAuthTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.icon,
    required this.keyboardType,
    required this.labelText,
    this.suffix,
    this.readOnly,
    this.validator,
    this.errorText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final Widget icon;
  final TextInputType keyboardType;
  final String labelText;
  final Widget? suffix;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final String? errorText;

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
            fontSize: 14.sp,
            color: color.secondary,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            icon: icon,
            suffixIcon: suffix,
            errorText: errorText,
            errorMaxLines: 2,
            errorStyle: TextStyle(
              color: color.tertiary,
            ),
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
