import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/const/text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 10.w,
        ),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                text: privacyPolicy,
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 14,
                ),
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
