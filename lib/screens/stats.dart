import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/const/sizing_config.dart';

import '../widgets/transaction_widget.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: GoogleFonts.poppins(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: null,
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.notifications_none,
              color: color.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalConverter(context, 20),
          vertical: verticalConverter(context, 10),
        ),
        child: ListView(
          children: [
            Text(
              'Monthly Spending',
              style: GoogleFonts.poppins(
                color: color.secondary,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "GHc 8,545.00",
              style: GoogleFonts.poppins(
                color: color.onPrimary,
                fontSize: 26,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            Image.asset('assets/images/charts.png'),
            Image.asset('assets/images/months.png'),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Recent Transactions',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: color.onPrimary,
                  ),
                ),
                Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: color.primary,
                  ),
                )
              ],
            ),
            const TransactionWidget(
              name: 'Spotify',
              category: 'Entertainment',
              icon: 'entertainment',
              isProfit: false,
              amount: 8.50,
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
