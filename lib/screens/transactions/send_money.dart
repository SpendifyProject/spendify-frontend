import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/credit_card.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/models/wallet.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/animations/empty.dart';
import 'package:spendify/screens/transactions/payment_webview.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/credit_card_widget.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:spendify/widgets/momo_widget.dart';
import 'package:uuid/uuid.dart';

import '../../const/constants.dart';
import '../../widgets/amount_text_field.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key, required this.user});

  final User user;

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  late WalletProvider walletProvider;
  late TextEditingController amountController;
  late TextEditingController recipientController;
  late TextEditingController referenceController;
  String? radioValue = 'momo';
  int? selectedCard = 0;
  String? selectedCategory;
  final formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  void initState() {
    super.initState();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    amountController = TextEditingController();
    recipientController = TextEditingController();
    referenceController = TextEditingController();
    amountController.text = '0.00';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: walletProvider.fetchWallet(widget.user, context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Wallet wallet = snapshot.data!;
          List<CreditCard> cards = wallet.creditCards;
          List<MomoAccount> momoAccounts = wallet.momoAccounts;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: color.onPrimary,
                  size: 20.sp,
                ),
              ),
              title: Text(
                'Send Money',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 18.sp,
                ),
              ),
            ),
            body: momoAccounts.isEmpty && cards.isEmpty
                ? const Empty(
                    text:
                        'Add a mobile money account or credit card to send money',
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    children: [
                      Form(
                        key: formKey,
                        child: SizedBox(
                          height: 310.h,
                          child: Column(
                            children: [
                              AmountTextField(
                                controller: amountController,
                                errorText: errorText,
                                validator: (value){
                                  errorText = Validator.validateAmount(value);
                                  return errorText;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomAuthTextField(
                                controller: recipientController,
                                obscureText: false,
                                icon: Icon(
                                  Icons.person_outline,
                                  color: color.secondary,
                                  size: 30.sp,
                                ),
                                keyboardType: TextInputType.text,
                                labelText: "Recipient",
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              CustomAuthTextField(
                                controller: referenceController,
                                obscureText: false,
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: color.secondary,
                                  size: 30.sp,
                                ),
                                keyboardType: TextInputType.text,
                                labelText: 'Reference',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Wrap(
                        spacing: 5.0,
                        children: List<Widget>.generate(
                          categories.length,
                          (int index) {
                            return ChoiceChip(
                              showCheckmark: false,
                              selectedColor: color.primary,
                              disabledColor: color.onSurface,
                              label: Text(
                                categories[index],
                              ),
                              selected: selectedCategory == categories[index],
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedCategory =
                                      selected ? categories[index] : null;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 'momo',
                            groupValue: radioValue,
                            onChanged: (newValue) {
                              setState(() {
                                radioValue = newValue;
                              });
                            },
                          ),
                          Text(
                            'Mobile Money',
                            style: TextStyle(
                              color: color.onPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Radio(
                            value: 'card',
                            groupValue: radioValue,
                            onChanged: (newValue) {
                              setState(() {
                                radioValue = newValue;
                              });
                            },
                          ),
                          Text(
                            'Credit Card',
                            style: TextStyle(
                              color: color.onPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 300.h,
                        child: ListView.builder(
                          itemCount: radioValue == 'momo'
                              ? momoAccounts.length
                              : cards.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    radioValue == "momo"
                                        ? MomoWidget(
                                            phoneNumber:
                                                momoAccounts[index].phoneNumber,
                                            fullName:
                                                momoAccounts[index].fullName,
                                            network:
                                                momoAccounts[index].network,
                                          )
                                        : CreditCardWidget(
                                            cardNumber: cards[index].cardNumber,
                                            fullName: cards[index].fullName,
                                            expiryDate:
                                                '${cards[index].expiryDate.month}/${cards[index].expiryDate.year}',
                                            assetName:
                                                '${cards[index].issuer.toLowerCase()}.png',
                                          ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                  ],
                                ),
                                Radio(
                                  value: index,
                                  groupValue: selectedCard,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCard = newValue;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            if (formKey.currentState!.validate()) {
                              double amount = double.parse(amountController.text);
                              String reference = referenceController.text;
                              String recipient = recipientController.text;
                              String id = const Uuid().v4();
                              String paymentMethod = radioValue == 'momo'
                                  ? momoAccounts[selectedCard ?? 0].id
                                  : cards[selectedCard ?? 0].id;
                              Transaction transaction = Transaction(
                                id: id,
                                uid: widget.user.uid,
                                recipient: recipient,
                                reference: reference,
                                date: DateTime.now(),
                                amount: amount,
                                paymentMethod: paymentMethod,
                                isDebit: true,
                                currency: 'GHS',
                                category: selectedCategory!,
                              );
                              setState(() {
                                errorText = null;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PaymentWebView(
                                      transaction: transaction,
                                    );
                                  },
                                ),
                              );
                            }

                          } catch (error) {
                            showErrorDialog(context, 'Error: $error}');
                          }
                        },
                        child: Text(
                          'Send Money',
                          style: TextStyle(
                            color: color.surface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          showErrorDialog(context, 'Error: ${snapshot.error}');
        }
        return const SizedBox();
      },
    );
  }
}
