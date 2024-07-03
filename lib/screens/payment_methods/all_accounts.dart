import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/credit_card.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/payment_methods/add_credit_card.dart';
import 'package:spendify/screens/payment_methods/add_momo_account.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:spendify/widgets/momo_widget.dart';

import '../../models/user.dart';
import '../../models/wallet.dart';
import '../../widgets/credit_card_widget.dart';

class AllCards extends StatefulWidget {
  const AllCards({super.key, required this.user});

  final User user;

  @override
  State<AllCards> createState() => _AllCardsState();
}

class _AllCardsState extends State<AllCards> {
  String selected = 'cards';
  late WalletProvider walletProvider;

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
          'All Accounts',
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
          vertical: 20.h,
          horizontal: 10.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SegmentedButton(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: 'cards',
                  label: Text(
                    'Credit Cards',
                  ),
                ),
                ButtonSegment(
                  value: 'momo',
                  label: Text(
                    'Mobile Money',
                  ),
                ),
              ],
              selected: {selected},
              onSelectionChanged: (value) {
                setState(() {
                  selected = value.first;
                });
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            FutureBuilder(
              future: walletProvider.fetchWallet(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  showErrorDialog(context, 'Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  Wallet wallet = snapshot.data ??
                      Wallet(
                        uid: 'WALLET_UNAVAILABLE',
                        creditCards: [],
                        momoAccounts: [],
                      );
                  List<CreditCard> cards = wallet.creditCards;
                  List<MomoAccount> momoAccounts = wallet.momoAccounts;
                  return SizedBox(
                    height: 500.h,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: selected == 'cards'
                          ? cards.length
                          : momoAccounts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            selected == 'cards'
                                ? CreditCardWidget(
                                    cardNumber: cards[index].cardNumber,
                                    fullName: cards[index].fullName,
                                    expiryDate:
                                        '${cards[index].expiryDate.month}/${cards[index].expiryDate.year}',
                                    assetName:
                                        '${cards[index].issuer.toLowerCase()}.png',
                                  )
                                : MomoWidget(
                                    phoneNumber:
                                        momoAccounts[index].phoneNumber,
                                    fullName: momoAccounts[index].fullName,
                                    network: momoAccounts[index].network,
                                  ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return selected == 'cards'
                            ? AddCard(uid: widget.user.uid)
                            : AddMomo(uid: widget.user.uid);
                      },
                    ),
                  );
                },
                child: Text(
                  selected == 'cards' ? 'Add Card' : 'Add Momo Account',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
