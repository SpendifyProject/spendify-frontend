import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/widgets/amount_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../const/constants.dart';
import '../../widgets/custom_auth_text_field.dart';

class RecordTransaction extends StatefulWidget {
  const RecordTransaction({super.key, required this.user});

  final User user;

  @override
  State<RecordTransaction> createState() => _RecordTransactionState();
}

class _RecordTransactionState extends State<RecordTransaction> {
  late TextEditingController amountController;
  late TextEditingController senderController;
  late TextEditingController recipientController;
  late TextEditingController referenceController;
  late TransactionProvider transactionProvider;
  final formKey = GlobalKey<FormState>();
  String? radioValue;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    amountController.text = '0.00';
    senderController = TextEditingController();
    recipientController = TextEditingController();
    referenceController = TextEditingController();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
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
          'Record Transaction',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        children: [
          Form(
            key: formKey,
            child: SizedBox(
              height: 470.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AmountTextField(
                    controller: amountController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Did you send or receive the money?',
                    style: TextStyle(
                      color: color.secondary,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: 'sent',
                        groupValue: radioValue,
                        onChanged: (newValue) {
                          setState(() {
                            radioValue = newValue;
                            senderController.text = widget.user.fullName;
                            recipientController.text = '';
                          });
                        },
                      ),
                      Text(
                        'Sent',
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Radio(
                        value: 'received',
                        groupValue: radioValue,
                        onChanged: (newValue) {
                          setState(() {
                            radioValue = newValue;
                            senderController.text = '';
                            recipientController.text = widget.user.fullName;
                          });
                        },
                      ),
                      Text(
                        'Received',
                        style: TextStyle(
                          color: color.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomAuthTextField(
                    controller: senderController,
                    obscureText: false,
                    icon: Icon(
                      Icons.person_outlined,
                      color: color.secondary,
                      size: 30,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: "Sender's Full Name",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomAuthTextField(
                    controller: recipientController,
                    obscureText: false,
                    icon: Icon(
                      Icons.person_pin_outlined,
                      color: color.secondary,
                      size: 30,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: "Recipient's Full Name",
                  ),
                  SizedBox(
                    height: 20.h,
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
          Wrap(
            spacing: 5.0,
            children: List<Widget>.generate(
              categories.length,
              (int index) {
                return ChoiceChip(
                  showCheckmark: false,
                  selectedColor: color.primary,
                  disabledColor: color.onBackground,
                  label: Text(categories[index]),
                  selected: selectedCategory == categories[index],
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategory = selected ? categories[index] : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
          SizedBox(
            height: 40.h,
          ),
          ElevatedButton(
            onPressed: () {
              try {
                if (formKey.currentState!.validate()) {}
                RecordedTransaction transaction = RecordedTransaction(
                  id: const Uuid().v4(),
                  uid: widget.user.uid,
                  amount: double.parse(amountController.text),
                  sender: senderController.text,
                  recipient: recipientController.text == widget.user.fullName
                      ? 'Cash In'
                      : recipientController.text,
                  reference: referenceController.text,
                  category: selectedCategory!,
                  date: DateTime.now(),
                  isDebit: senderController.text == widget.user.fullName,
                  currency: 'GHS',
                );
                transactionProvider.recordExternalTransaction(transaction);
                showCustomSnackbar(
                    context, 'Transaction recorded successfully');
              } catch (error) {
                showErrorDialog(context, '$error');
              }
            },
            child: Text(
              'Record',
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
  }
}
