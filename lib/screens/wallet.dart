import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/sizing_config.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/widgets/double_header.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../widgets/credit_card_widget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late UserProvider userProvider;
  bool isLoading = true;
  String email = auth.FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
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
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.monetization_on_outlined,
              color: color.onPrimary,
              size: 30,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: userProvider.getUserData(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading = true;
            return const SizedBox();
          } else if (snapshot.hasError) {
            showErrorDialog(context, 'Error: ${snapshot.error}');
          } else {
            final User user = userProvider.user;
            isLoading = false;
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalConverter(context, 10),
                horizontal: horizontalConverter(context, 20),
              ),
              child: ListView(
                children: [
                  Text(
                    'Monthly spending limit',
                    style: TextStyle(
                      fontSize: 18,
                      color: color.onPrimary,
                    ),
                  ),
                  SizedBox(
                    height: verticalConverter(context, 10),
                  ),
                  Center(
                    child: Expanded(
                      child: Container(
                        width: horizontalConverter(context, 335),
                        height: verticalConverter(context, 113),
                        padding: EdgeInsets.all(
                          verticalConverter(context, 20),
                        ),
                        decoration: BoxDecoration(
                          color: color.onBackground,
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
                              'Expenses: GHc4,658.00',
                              style: TextStyle(
                                fontSize: 13,
                                color: color.onPrimary,
                              ),
                            ),
                            LinearProgressIndicator(
                              value: 0.4,
                              color: color.primary,
                              backgroundColor: color.background,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: verticalConverter(context, 25),
                  ),
                  const DoubleHeader(
                    leading: 'Last Card Used',
                    trailing: 'All Cards',
                  ),
                  SizedBox(
                    height: verticalConverter(context, 10),
                  ),
                  CreditCardWidget(
                    cardNumber: '4562   1122   4595   7852',
                    fullName: user.fullName,
                    expiryDate: '12/2024',
                    assetName: 'mastercard.png',
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
