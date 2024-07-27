import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionButton extends StatelessWidget {
  const TransactionButton(
      {super.key, required this.iconData, required this.label, this.onTap});

  final IconData iconData;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color.onSurface,
            radius: 27.r,
            child: Icon(
              iconData,
              color: color.onPrimary,
              size: 30.sp,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 13.sp,
          ),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}