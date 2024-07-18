import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/models/wallet.dart' as w;
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/animations/empty.dart';
import 'package:spendify/screens/dashboard/budget/new_savings_goal.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/screens/payment_methods/add_credit_card.dart';
import 'package:spendify/screens/payment_methods/add_momo_account.dart';
import 'package:spendify/services/gemini_service.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../../const/tips.dart';
import '../home/home.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key, required this.user});

  final User user;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = true;
  late WalletProvider walletProvider;
  late TransactionProvider transactionProvider;
  double limit = 0;
  final TextEditingController limitController = TextEditingController();
  late SharedPreferences _prefs;
  w.Wallet? wallet;
  String? limitError;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    initPrefs();
    fetchWalletData();
  }

  Future<void> initPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      limit = preferences.getDouble('spendingLimit') ?? 0;
      _prefs = preferences;
    });
  }

  Future<void> fetchWalletData() async {
    try {
      w.Wallet fetchedWallet =
          await walletProvider.fetchWallet(widget.user, context);
      setState(() {
        wallet = fetchedWallet;
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    limitController.text = limit.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: wallet == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 20.w,
              ),
              children: [
                if (transactionProvider.transactions.isEmpty)
                  const Empty(
                    text: 'Make some transactions to view this screen',
                  )
                else ...[
                  SizedBox(
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly spending limit',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: color.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 335.w,
                              height: 115.h,
                              padding: EdgeInsets.all(
                                20.h,
                              ),
                              decoration: BoxDecoration(
                                color: color.onSurface,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Limit: GHc ${formatAmount(limit)}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: color.onPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Monthly Income: GHc ${formatAmount(wallet!.monthlyIncome)}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: color.onPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Expenses: GHc ${formatAmount(wallet!.monthlyExpenses)}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: color.onPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  LinearProgressIndicator(
                                    value: limit > 0
                                        ? wallet!.monthlyExpenses / limit
                                        : 0.01,
                                    color: color.primary,
                                    backgroundColor: color.surface,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: Offset(-20.w, 10.h),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: color.surface,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: 200.h,
                                            width: 200.w,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 10.h,
                                              ),
                                              child: Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'New Spending Limit',
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: color.secondary,
                                                      ),
                                                    ),
                                                    CustomAuthTextField(
                                                      controller:
                                                          limitController,
                                                      obscureText: false,
                                                      errorText: limitError,
                                                      validator: (value) {
                                                        limitError = Validator
                                                            .validateAmount(
                                                                value);
                                                        return limitError;
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        size: 30.sp,
                                                        color: color.secondary,
                                                      ),
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(),
                                                      labelText: '',
                                                    ),
                                                    const Spacer(),
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          await _prefs
                                                              .setDouble(
                                                            'spendingLimit',
                                                            double.parse(
                                                                limitController
                                                                    .text),
                                                          );
                                                          setState(() {
                                                            limitError = null;
                                                          });
                                                          popAndPushReplacement(
                                                            context,
                                                            Dashboard(
                                                                email:
                                                                    firebaseEmail),
                                                          );
                                                          setState(() {
                                                            limit = double.parse(
                                                                limitController
                                                                    .text);
                                                          });
                                                        }
                                                      },
                                                      child: const Text('Save'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: color.primary,
                                    radius: 20.r,
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: color.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
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
                                    return AddCard(uid: widget.user.uid);
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
                                    return AddMomo(uid: widget.user.uid);
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
                                    return NewSavingsGoal(uid: widget.user.uid);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'General financial tip',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: color.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCustomSnackbar(context,
                              'These are tips obtained from the internet from experts and reliable sources on finance, healthy spending habits and responsible financial management.');
                        },
                        child: Icon(
                          Icons.info_outlined,
                          color: color.onSecondary,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    width: double.infinity,
                    // height: 220.h,
                    decoration: BoxDecoration(
                      color: color.onSurface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      getTip(context),
                      style: TextStyle(
                        color: color.onPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Specialised financial tip',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: color.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCustomSnackbar(context,
                              'These are tips generated by the Google Gemini AI model based on your income, budget and expenses.');
                        },
                        child: Icon(
                          Icons.info_outlined,
                          color: color.onSecondary,
                        ),
                      )
                    ],
                  ),
                  FutureBuilder(
                    future: GeminiService().generateText(
                        wallet!.monthlyIncome, wallet!.monthlyExpenses, limit),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: 180.h,
                          decoration: BoxDecoration(
                            color: color.onSurface,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        final text = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          width: double.infinity,
                          // height: 220.h,
                          decoration: BoxDecoration(
                            color: color.onSurface,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: color.onPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ],
            ),
    );
  }
}
