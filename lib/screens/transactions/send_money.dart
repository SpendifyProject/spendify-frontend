import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/sizing_config.dart';
import 'package:spendify/models/credit_card.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/models/wallet.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/transactions/payment_webview.dart';
import 'package:spendify/widgets/credit_card_widget.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:spendify/widgets/momo_widget.dart';
import 'package:uuid/uuid.dart';

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
  final formKey = GlobalKey<FormState>();
  String paystackApi = dotenv.env['PAYSTACK_KEY'] ?? 'NO_API_KEY_FOUND';

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
      future: walletProvider.fetchWallet(widget.user),
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
                  size: 20,
                ),
              ),
              title: Text(
                'Send Money',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 18,
                ),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalConverter(context, 20),
                vertical: verticalConverter(context, 10),
              ),
              children: [
                Form(
                  key: formKey,
                  child: SizedBox(
                    height: verticalConverter(context, 280),
                    child: Column(
                      children: [
                        Container(
                          height: verticalConverter(context, 116),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: color.secondary,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: verticalConverter(context, 20),
                            horizontal: horizontalConverter(context, 10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Your Amount',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: color.onSecondary,
                                ),
                              ),
                              SizedBox(
                                height: verticalConverter(context, 10),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'GHc',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(155, 178, 212, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: horizontalConverter(context, 15),
                                  ),
                                  SizedBox(
                                    width: horizontalConverter(context, 200),
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: color.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: verticalConverter(context, 20),
                        ),
                        CustomAuthTextField(
                          controller: recipientController,
                          obscureText: false,
                          icon: Icon(
                            Icons.person_outline,
                            color: color.secondary,
                            size: 30,
                          ),
                          keyboardType: TextInputType.number,
                          labelText: 'Recipient Phone Number',
                        ),
                        SizedBox(
                          height: verticalConverter(context, 15),
                        ),
                        CustomAuthTextField(
                          controller: referenceController,
                          obscureText: false,
                          icon: Icon(
                            Icons.message_outlined,
                            color: color.secondary,
                            size: 30,
                          ),
                          keyboardType: TextInputType.text,
                          labelText: 'Reference',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: verticalConverter(context, 20),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: horizontalConverter(context, 20),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: verticalConverter(context, 10),
                ),
                SizedBox(
                  height: verticalConverter(context, 220),
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
                                      fullName: momoAccounts[index].fullName,
                                      network: momoAccounts[index].network,
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
                                width: horizontalConverter(context, 20),
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
                      );
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
                    } catch (error) {
                      showErrorDialog(context, 'Error: $error}');
                    }
                  },
                  child: Text(
                    'Send Money',
                    style: TextStyle(
                      color: color.background,
                      fontSize: 16,
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
