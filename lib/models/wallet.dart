import 'package:flutter/material.dart';

import 'credit_card.dart';
import 'momo_accounts.dart';

class Wallet extends ChangeNotifier {
  String uid;
  double monthlyIncome;
  double monthlyExpenses;
  final List<CreditCard> creditCards;
  final List<MomoAccount> momoAccounts;

  Wallet({
    required this.uid,
    required this.creditCards,
    required this.momoAccounts,
    required this.monthlyIncome,
    required this.monthlyExpenses,
  });
}
