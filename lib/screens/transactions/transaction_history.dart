import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendify/const/sizing_config.dart';

import '../../widgets/transaction_widget.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction History',
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
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              CupertinoIcons.search,
              color: color.secondary,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalConverter(context, 20),
          horizontal: horizontalConverter(context, 10),
        ),
        child: ListView(
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontSize: 18,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            const TransactionWidget(
              name: 'Spotify',
              category: 'Entertainment',
              icon: 'entertainment',
              isProfit: false,
              amount: 8.50,
            ),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            Text(
              'Yesterday',
              style: TextStyle(
                fontSize: 18,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            const TransactionWidget(
              name: 'Apple TV',
              category: 'Entertainment',
              icon: 'entertainment',
              isProfit: false,
              amount: 12.99,
            ),
            const TransactionWidget(
              name: 'Groceries',
              category: 'Food and Dining',
              icon: 'food',
              isProfit: false,
              amount: 30,
            ),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            Text(
              'Earlier',
              style: TextStyle(
                fontSize: 18,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 10),
            ),
            const TransactionWidget(
              name: 'Cash In',
              category: 'Money Transfer',
              icon: 'transfer',
              isProfit: true,
              amount: 300,
            ),
            const TransactionWidget(
              name: 'Gym Membership',
              category: 'Health and Fitness',
              icon: 'health',
              isProfit: false,
              amount: 250,
            ),
          ],
        ),
      ),
    );
  }
}
