import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spendify/const/auth.dart';
import 'package:spendify/const/sizing_config.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/user_provider.dart';

import '../widgets/credit_card_widget.dart';
import '../widgets/error_dialog.dart';
import '../widgets/transaction_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.email});
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    bool isLoading = false;
    return Scaffold(
      body: FutureBuilder(
        future: userProvider.getUserData(widget.email),
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
                  horizontal: horizontalConverter(context, 20),
                  vertical: verticalConverter(context, 10)),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Skeletonizer(
                    enabled: isLoading,
                    child: ListTile(
                      isThreeLine: true,
                      contentPadding: EdgeInsets.zero,
                      leading: GestureDetector(
                        onTap: () {
                          signOut(context);
                        },
                        child: ClipOval(
                          child: Image.network(
                            user.imagePath,
                            width: horizontalConverter(context, 50),
                            height: verticalConverter(context, 50),
                          ),
                        ),
                      ),
                      title: Text(
                        'Welcome,',
                        style: TextStyle(
                          color: color.secondary,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        user.fullName,
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: verticalConverter(context, 32),
                  ),
                  CreditCardWidget(
                    cardNumber: '4562   1122   4595   7852',
                    fullName: user.fullName,
                    expiryDate: '12/2024',
                    assetName: 'mastercard.png',
                  ),
                  SizedBox(
                    height: verticalConverter(context, 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Transactions',
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
