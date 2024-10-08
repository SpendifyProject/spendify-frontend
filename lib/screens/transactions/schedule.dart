import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/screens/animations/done.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/amount_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../const/constants.dart';
import '../../models/notification.dart' as n;
import '../../provider/biometric_provider.dart';
import '../../services/biometric_service.dart';
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
  String? errorText;

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

  void _scheduleTransaction() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          errorText = null;
        });
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
          body:
              'Your transaction of GHc ${formatAmount(double.parse(amountController.text))} to ${recipientController.text} has been processed successfully',
          date: _selectedDate!,
          id: const Uuid().v4(),
          uid: widget.user.uid,
        );
        await NotificationService.scheduleNotification(notification);
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

  Future<void> _authenticateAndSchedule() async {
    final BiometricProvider biometricProvider =
        Provider.of<BiometricProvider>(context, listen: false);

    if (biometricProvider.isBiometricEnabled) {
      try {
        await BiometricService.authenticate(context);
        _scheduleTransaction();
      } catch (e) {
        showErrorDialog(context, 'Authentication failed. Please try again.');
      }
    } else {
      _scheduleTransaction();
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
                    errorText: errorText,
                    validator: (value) {
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
                            barrierDismissible: false,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: color.primary,
                                  colorScheme:
                                      const ColorScheme.light().copyWith(
                                    primary: color.primary,
                                    onPrimary: color.onPrimary,
                                  ),
                                  dialogBackgroundColor: color.surface,
                                  textTheme: GoogleFonts.poppinsTextTheme(),
                                ),
                                child: child!,
                              );
                            }).then((pickedDate) {
                          if (pickedDate == null) {
                            showCustomSnackbar(
                              context,
                              'Please select your next payment date',
                            );
                            return;
                          } else {
                            setState(() {
                              _selectedDate = pickedDate;
                              dateController.text = formatDate(_selectedDate!);
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
            onPressed: _authenticateAndSchedule,
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
