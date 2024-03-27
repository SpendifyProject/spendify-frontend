import 'package:flutter/material.dart';
import 'package:spendify/const/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            signOut(context);
          },
          child: Text(
            'Sign Out',
            style: TextStyle(
              color: color.background,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
