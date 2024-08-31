import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/biometric_provider.dart';
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/services/biometric_service.dart';
import 'package:spendify/services/notification_service.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/amount_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:spendify/models/notification.dart' as n;

import '../../const/constants.dart';
import '../../widgets/custom_auth_text_field.dart';
import '../animations/done.dart';
import '../dashboard/dashboard.dart';

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
  String? errorText;

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

  Future<void> _authenticateAndRecord() async{
    final BiometricProvider biometricProvider = Provider.of<BiometricProvider>(context, listen: false);

    if(biometricProvider.isBiometricEnabled){
      try{
        await BiometricService.authenticate(context);
        _recordTransaction();
      }
      catch(error){
        showErrorDialog(context, 'Authentication failed. Please try again');
      }
    }
    else{
      _recordTransaction();
    }
  }

  void _recordTransaction() async{
    try {
      if (formKey.currentState!.validate()) {
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
        n.Notification notification = n.Notification(
          title: 'Recorded Transaction',
          body:
          'Your transaction of GHc ${formatAmount(double.parse(amountController.text))} ${senderController.text == widget.user.fullName ? 'to ${recipientController.text}' : 'from ${senderController.text}'} has been recorded.',
          date: DateTime.now(),
          id: const Uuid().v4(),
          uid: widget.user.uid,
        );
        setState(() {
          errorText = null;
        });
        await NotificationService.showInstantNotification(notification);
        showCustomSnackbar(
          context,
          'Transaction recorded successfully',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DoneScreen(
                nextPage: Dashboard(email: firebaseEmail),
              );
            },
          ),
        );
      }
    } catch (error) {
      showErrorDialog(context, '$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {});
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Record Transaction',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
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
                    errorText: errorText,
                    validator: (value){
                      errorText = Validator.validateAmount(value);
                      return errorText;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Did you send or receive the money?',
                    style: TextStyle(
                      color: color.secondary,
                      fontSize: 12.sp,
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
                          fontSize: 14.sp,
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
                          fontSize: 14.sp,
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
                      size: 30.sp,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: "Sender",
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
                      size: 30.sp,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: "Recipient",
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
                      size: 30.sp,
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
                  disabledColor: color.onSurface,
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
            onPressed: _authenticateAndRecord,
            child: Text(
              'Record',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
