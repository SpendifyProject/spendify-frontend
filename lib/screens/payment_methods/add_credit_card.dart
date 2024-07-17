import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/credit_card.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/custom_auth_text_field.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key, required this.uid});

  final String uid;

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController dateController;
  late TextEditingController issuerController;
  DateTime? _selectedDate;
  String _selectedIssuer = '';
  late WalletProvider walletProvider;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    dateController = TextEditingController();
    issuerController = TextEditingController();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Card',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 10.w,
        ),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomAuthTextField(
                    controller: nameController,
                    obscureText: false,
                    icon: Icon(
                      Icons.person_outline,
                      color: color.secondary,
                      size: 30.sp,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: 'Cardholder Full Name',
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomAuthTextField(
                    controller: numberController,
                    obscureText: false,
                    icon: Icon(
                      Icons.credit_card,
                      color: color.secondary,
                      size: 30.sp,
                    ),
                    keyboardType: TextInputType.number,
                    labelText: 'Card Number',
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
                            lastDate: DateTime(2040),
                            initialDate: DateTime.now(),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select the expiry date'),
                              ),
                            );
                            return;
                          } else {
                            setState(() {
                              _selectedDate = pickedDate;
                              dateController.text =
                                  '${_selectedDate?.month}/${_selectedDate?.year}';
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
                    labelText: 'Expiry Date',
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomAuthTextField(
                    controller: issuerController,
                    obscureText: false,
                    icon: Icon(
                      Icons.business_center_outlined,
                      color: color.secondary,
                      size: 30.sp,
                    ),
                    suffix: PopupMenuButton(
                      onSelected: (String value) {
                        setState(() {
                          _selectedIssuer = value;
                          issuerController.text = _selectedIssuer;
                        });
                      },
                      color: color.surface,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Mastercard',
                          child: Text(
                            'Mastercard',
                            style: TextStyle(
                              color: color.onPrimary,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Visa',
                          child: Text(
                            'Visa',
                            style: TextStyle(
                              color: color.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    keyboardType: TextInputType.text,
                    labelText: 'Issuer',
                    readOnly: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  try {
                    final form = formKey.currentState!;
                    if (form.validate()) {}
                    String fullName = nameController.text;
                    String cardNumber = numberController.text;
                    DateTime expiryDate = _selectedDate!;
                    String issuer = _selectedIssuer;
                    Uuid id = const Uuid();
                    String uid = widget.uid;

                    CreditCard newCard = CreditCard(
                      fullName: fullName,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      issuer: issuer,
                      uid: uid,
                      id: id.v4(),
                    );

                    walletProvider.saveCard(newCard);
                    showCustomSnackbar(
                      context,
                      'Credit card saved successfully',
                    );
                    Navigator.pop(context);
                  } catch (error) {
                    showErrorDialog(context, 'Error: $error');
                  }
                },
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    color: color.surface,
                    fontSize: 14.sp,
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
