import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/done.json',
        ),
      ),
    );
  }
}
