import 'package:flutter/material.dart';
import 'package:spendify/const/sizing_config.dart';
import 'package:spendify/const/text.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
          vertical: verticalConverter(context, 20),
          horizontal: horizontalConverter(context, 10),
        ),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                text: termsAndConditions,
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
