import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoubleHeader extends StatelessWidget {
  const DoubleHeader(
      {super.key,
      required this.leading,
      required this.trailing,
      this.onTap});

  final String leading;
  final String trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          leading,
          style: TextStyle(
            fontSize: 18.sp,
            color: color.onPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            trailing,
            style: TextStyle(
              fontSize: 14.sp,
              color: color.primary,
            ),
          ),
        )
      ],
    );
  }
}
