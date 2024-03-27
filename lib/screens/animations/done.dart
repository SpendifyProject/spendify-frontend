import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return widget.nextPage;
        }),
      );
    });
  }

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
