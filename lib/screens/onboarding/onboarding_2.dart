import 'package:flutter/material.dart';
import '../../const/sizing_config.dart';
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
          Padding(
            padding: EdgeInsets.only(
              top: verticalConverter(context, 145),
              left: horizontalConverter(context, 20),
            ),
            child: Image.asset(
              'assets/images/onboarding_2.png',
              width: horizontalConverter(context, 335),
              height: verticalConverter(context, 248.53),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalConverter(context, 20),
              horizontal: horizontalConverter(context, 47),
            ),
            child: const Center(
              child: Text(
                'The most Secure Platform for Customer',
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
              horizontal: horizontalConverter(context, 52),
            ),
            child: Center(
              child: Text(
                'Built-in Fingerprint, face recognition and more, keeping you completely safe',
                style: TextStyle(
                  fontSize: 14,
                  color: color.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalConverter(context, 30),
              horizontal: horizontalConverter(context, 20),
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
          )
        ],
      ),
    );
  }
}
