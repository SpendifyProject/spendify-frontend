import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/widgets/double_header.dart';

import '../../widgets/transaction_widget.dart';

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
          horizontal: 20.w,
          vertical: 20.h,
        ),
        child: ListView(
          children: [
            Text(
              'Monthly Expenses',
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
              height: 20.h,
            ),
            Image.asset('assets/images/charts.png'),
            Image.asset('assets/images/months.png'),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Category Chart',
              style: GoogleFonts.poppins(
                color: color.secondary,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/images/category.png'),
            Image.asset('assets/images/legend.png'),
            SizedBox(
              height: 20.h,
            ),
            const DoubleHeader(
              leading: 'Recent Transactions',
              trailing: 'See All',
            ),
            const TransactionWidget(
              name: 'Spotify',
              category: 'Entertainment',
              icon: 'entertainment',
              isDebit: false,
              amount: 8.50,
            ),
            const TransactionWidget(
              name: 'Apple TV',
              category: 'Entertainment',
              icon: 'entertainment',
              isDebit: false,
              amount: 12.99,
            ),
            const TransactionWidget(
              name: 'Groceries',
              category: 'Food and Dining',
              icon: 'food',
              isDebit: false,
              amount: 30,
            ),
            const TransactionWidget(
              name: 'Cash In',
              category: 'Money Transfer',
              icon: 'transfer',
              isDebit: true,
              amount: 300,
            ),
            const TransactionWidget(
              name: 'Gym Membership',
              category: 'Health and Fitness',
              icon: 'health',
              isDebit: false,
              amount: 250,
            ),
          ],
        ),
      ),
    );
  }
}
