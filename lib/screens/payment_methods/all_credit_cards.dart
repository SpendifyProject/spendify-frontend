import 'package:flutter/material.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/const/sizing_config.dart';

import '../../widgets/credit_card_widget.dart';

class AllCards extends StatelessWidget {
  const AllCards({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Cards',
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
            color: color.secondary,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalConverter(context, 20),
          horizontal: horizontalConverter(context, 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: verticalConverter(context, 550),
              child: ListView(
                children: [
                  const CreditCardWidget(
                    cardNumber: '4562   1122   4595   7852',
                    fullName: 'Full Name',
                    expiryDate: '12/2024',
                    assetName: 'mastercard.png',
                  ),
                  SizedBox(
                    height: verticalConverter(context, 10),
                  ),
                  const CreditCardWidget(
                    cardNumber: '4562   1122   4595   7852',
                    fullName: 'Full Name',
                    expiryDate: '12/2024',
                    assetName: 'visa.png',
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, addCardRoute);
              },
              child: Text(
                'Add Card',
                style: TextStyle(
                  color: color.background,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
