import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'onboarding_3.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
            ),
            child: Image.asset(
              'assets/images/onboarding_2.png',
              width: 335.w,
              height: 248.53.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 47.w,
            ),
            child: const Center(
              child: Text(
                'Set Budget and Spending Goals',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 52.w,
            ),
            child: Center(
              child: Text(
                'Spendify helps you take control of your finances by setting realistic spending goals',
                style: TextStyle(
                  fontSize: 14,
                  color: color.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Onboarding3();
                    },
                  ),
                );
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
