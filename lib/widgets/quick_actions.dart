import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/widgets/transaction_button.dart';

import '../models/user.dart';
import '../screens/dashboard/budget/new_savings_goal.dart';
import '../screens/payment_methods/add_credit_card.dart';
import '../screens/payment_methods/add_momo_account.dart';
import '../screens/transactions/record.dart';
import '../screens/transactions/schedule.dart';
import '../screens/transactions/send_money.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TransactionButton(
              iconData: Icons.arrow_upward,
              label: 'Send',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SendMoney(user: user);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TransactionButton(
              iconData: Icons.schedule_outlined,
              label: 'Schedule',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ScheduleTransaction(
                        user: user,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TransactionButton(
              iconData: Icons.add,
              label: 'Record',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTransaction(
                        user: user,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetQuickActions extends StatelessWidget {
  const BudgetQuickActions({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TransactionButton(
              iconData: Icons.credit_card,
              label: 'Add Card',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddCard(uid: uid);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TransactionButton(
              iconData: Icons.monetization_on_outlined,
              label: 'Add Momo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddMomo(uid: uid);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TransactionButton(
              iconData: Icons.savings_outlined,
              label: 'New Savings Goal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NewSavingsGoal(uid: uid);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
