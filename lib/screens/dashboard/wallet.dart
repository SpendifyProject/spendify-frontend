import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/models/wallet.dart' as w;
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/payment_methods/add_credit_card.dart';
import 'package:spendify/screens/payment_methods/add_momo_account.dart';
import 'package:spendify/widgets/double_header.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:spendify/widgets/momo_widget.dart';

import '../../widgets/credit_card_widget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key, required this.user});

  final User user;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = true;
  late WalletProvider walletProvider;
  double limit = 10000.00;

  @override
  void initState() {
    super.initState();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (String value) {
              if (value == 'card') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddCard(uid: widget.user.uid);
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddMomo(uid: widget.user.uid);
                    },
                  ),
                );
              }
            },
            color: color.background,
            icon: Icon(
              Icons.monetization_on_outlined,
              color: color.onPrimary,
              size: 30,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'card',
                child: Text('Add new credit card'),
              ),
              const PopupMenuItem<String>(
                value: 'momo',
                child: Text('Add new mobile money account'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: walletProvider.fetchWallet(widget.user, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          }
          w.Wallet wallet = snapshot.data ??
              w.Wallet(
                uid: 'WALLET_UNAVAILABLE',
                creditCards: [],
                momoAccounts: [],
                monthlyExpenses: 0,
                monthlyIncome: 0,
              );
          return ListView(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 20.w,
            ),
            children: [
              Text(
                'Monthly spending limit',
                style: TextStyle(
                  fontSize: 18,
                  color: color.onPrimary,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Expanded(
                  child: Container(
                    width: 335.w,
                    height: 113.h,
                    padding: EdgeInsets.all(
                      20.h,
                    ),
                    decoration: BoxDecoration(
                      color: color.onSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Limit: GHc10,000.00',
                          style: TextStyle(
                            fontSize: 13,
                            color: color.onPrimary,
                          ),
                        ),
                        Text(
                          'Expenses: GHc${wallet.monthlyExpenses.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: color.onPrimary,
                          ),
                        ),
                        LinearProgressIndicator(
                          value: wallet.monthlyExpenses/limit,
                          color: color.primary,
                          backgroundColor: color.surface,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              const DoubleHeader(
                leading: 'Last Card Used',
                trailing: 'View History',
              ),
              SizedBox(
                height: 10.h,
              ),
              CreditCardWidget(
                cardNumber: '4562112245957852',
                fullName: widget.user.fullName,
                expiryDate: '12/2024',
                assetName: 'mastercard.png',
              ),
              SizedBox(
                height: 10.h,
              ),
              MomoWidget(
                phoneNumber: '0263600727',
                fullName: widget.user.fullName,
                network: 'mtn',
              ),
            ],
          );
        },
      ),
    );
  }
}
