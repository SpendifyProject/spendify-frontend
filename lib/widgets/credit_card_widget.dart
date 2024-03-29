import 'package:flutter/material.dart';

import '../const/sizing_config.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget(
      {super.key,
        required this.cardNumber,
        required this.fullName,
        required this.expiryDate,
        required this.assetName});

  final String cardNumber;
  final String fullName;
  final String expiryDate;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: horizontalConverter(context, 335),
      height: verticalConverter(context, 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.onPrimary,
        image: const DecorationImage(
          image: AssetImage('assets/images/worldmap.png'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(verticalConverter(context, 20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Text(
              cardNumber,
              style: TextStyle(
                color: color.background,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            Text(
              fullName,
              style: TextStyle(
                color: color.background,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Expiry Date',
                style: TextStyle(
                  color: color.secondary,
                  fontSize: 9,
                ),
              ),
              subtitle: Text(
                expiryDate,
                style: TextStyle(
                  color: color.background,
                  fontSize: 13,
                ),
              ),
              trailing: Image.asset('assets/images/$assetName'),
            ),
          ],
        ),
      ),
    );
  }
}
