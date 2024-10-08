import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:uuid/uuid.dart';

import '../../const/constants.dart';
import '../../widgets/custom_auth_text_field.dart';
import '../../widgets/error_dialog.dart';
import '../animations/done.dart';
import '../dashboard/dashboard.dart';

class AddMomo extends StatefulWidget {
  const AddMomo({super.key, required this.uid});

  final String uid;

  @override
  State<AddMomo> createState() => _AddMomoState();
}

class _AddMomoState extends State<AddMomo> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController networkController;
  String _selectedNetwork = '';
  late WalletProvider walletProvider;
  String? nameError;
  String? numberError;
  String? providerError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    networkController = TextEditingController();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Mobile Money Account',
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
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 10.w,
        ),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomAuthTextField(
                  controller: nameController,
                  obscureText: false,
                  errorText: nameError,
                  validator: (value) {
                    nameError = Validator.validateName(value);
                    return nameError;
                  },
                  icon: Icon(
                    Icons.person_outline,
                    color: color.secondary,
                    size: 30.sp,
                  ),
                  keyboardType: TextInputType.text,
                  labelText: 'Full Name',
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  controller: numberController,
                  obscureText: false,
                  errorText: numberError,
                  validator: (value) {
                    numberError = Validator.validatePhoneNumber(value);
                    return numberError;
                  },
                  icon: Icon(
                    Icons.credit_card,
                    color: color.secondary,
                    size: 30.sp,
                  ),
                  keyboardType: TextInputType.number,
                  labelText: 'Phone Number',
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  controller: networkController,
                  obscureText: false,
                  errorText: providerError,
                  validator: (value) {
                    if (_selectedNetwork == '') {
                      providerError = 'Please select a network provider';
                      return providerError;
                    }
                    return null;
                  },
                  icon: Icon(
                    Icons.business_center_outlined,
                    color: color.secondary,
                    size: 30.sp,
                  ),
                  suffix: PopupMenuButton(
                    onSelected: (String value) {
                      setState(() {
                        _selectedNetwork = value;
                        networkController.text = _selectedNetwork;
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
                        value: 'mtn',
                        child: Text(
                          'MTN',
                          style: TextStyle(
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'telecel',
                        child: Text(
                          'Telecel',
                          style: TextStyle(
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'airtel',
                        child: Text(
                          'AirtelTigo',
                          style: TextStyle(
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  keyboardType: TextInputType.text,
                  labelText: 'Mobile Network Provider',
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
                  if (form.validate()) {
                    String fullName = nameController.text;
                    String phoneNumber = numberController.text;
                    String network = networkController.text;
                    Uuid id = const Uuid();
                    String uid = widget.uid;

                    MomoAccount newAccount = MomoAccount(
                      id: id.v4(),
                      uid: uid,
                      fullName: fullName,
                      network: network,
                      phoneNumber: phoneNumber,
                    );

                    walletProvider.saveAccount(newAccount);
                    showCustomSnackbar(
                      context,
                      'Mobile money account saved successfully',
                    );
                    setState(() {
                      nameError = null;
                      numberError = null;
                      providerError = null;
                    });
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
                  showErrorDialog(context, 'Error: $error');
                }
              },
              child: Text(
                'Add Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
