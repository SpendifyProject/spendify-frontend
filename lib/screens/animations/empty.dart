import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatelessWidget {
  const Empty({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 300.h,
          child: Lottie.asset(
            'assets/animations/empty.json',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Text(
            text,
            style: TextStyle(
              color: color.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
