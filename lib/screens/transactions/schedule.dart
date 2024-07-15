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
import '../../models/notification.dart' as n;
import '../../services/notification_service.dart';
import '../../widgets/custom_auth_text_field.dart';

class ScheduleTransaction extends StatefulWidget {
  const ScheduleTransaction({super.key, required this.user});

  final User user;

  @override
  State<ScheduleTransaction> createState() => _ScheduleTransactionState();
}

class _ScheduleTransactionState extends State<ScheduleTransaction> {
  late TextEditingController amountController;
  late TextEditingController referenceController;
  late TextEditingController dateController;
  late TextEditingController recipientController;
  late TransactionProvider transactionProvider;
  DateTime? _selectedDate;
  String? selectedCategory;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    amountController.text = '0.00';
    referenceController = TextEditingController();
    dateController = TextEditingController();
    recipientController = TextEditingController();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    referenceController.dispose();
    dateController.dispose();
    recipientController.dispose();
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
            size: 20.sp,
          ),
        ),
        title: Text(
          'Schedule Payments',
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
              height: 390.h,
              child: Column(
                children: [
                  AmountTextField(
                    controller: amountController,
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
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomAuthTextField(
                    controller: dateController,
                    obscureText: false,
                    icon: Icon(
                      Icons.date_range_outlined,
                      color: color.secondary,
                      size: 30.sp,
                    ),
                    suffix: GestureDetector(
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                          initialDate: DateTime.now(),
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            showCustomSnackbar(context, 'Please select your next payment date',);
                            return;
                          } else {
                            setState(() {
                              _selectedDate = pickedDate;
                              dateController.text =
                                  '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}';
                            });
                          }
                        });
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    labelText: 'Next Payment Date',
                    readOnly: true,
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
            height: 30.h,
          ),
          ElevatedButton(
            onPressed: () async{
              try {
                if (formKey.currentState!.validate()) {}
                ScheduledTransaction transaction = ScheduledTransaction(
                  id: const Uuid().v4(),
                  uid: widget.user.uid,
                  reference: referenceController.text,
                  recipient: recipientController.text,
                  amount: double.parse(amountController.text),
                  scheduledDate: _selectedDate!,
                  category: selectedCategory!,
                  isDebit: true,
                  currency: 'GHS',
                );
                transactionProvider.scheduleTransaction(transaction);
                showCustomSnackbar(
                  context,
                  'Transaction scheduled for ${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year} successfully',
                );
                n.Notification notification = n.Notification(
                  title: 'Transaction Completed',
                  body: 'Your transaction of GHc ${formatAmount(double.parse(amountController.text))} to ${recipientController.text} has been processed successfully',
                  date: _selectedDate!,
                );
                await NotificationService.scheduleNotification(notification);
                Navigator.pop(context);
              } catch (error) {
                showErrorDialog(context, '$error');
              }
            },
            child: Text(
              'Save',
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
