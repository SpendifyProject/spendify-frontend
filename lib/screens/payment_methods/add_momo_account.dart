import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/custom_auth_text_field.dart';
import '../../widgets/error_dialog.dart';

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
          'Add New Mobile Money Account',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
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
                      size: 30,
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
                    icon: Icon(
                      Icons.credit_card,
                      color: color.secondary,
                      size: 30,
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
                    icon: Icon(
                      Icons.business_center_outlined,
                      color: color.secondary,
                      size: 30,
                    ),
                    suffix: PopupMenuButton(
                      onSelected: (String value) {
                        setState(() {
                          _selectedNetwork = value;
                          networkController.text = _selectedNetwork;
                        });
                      },
                      color: color.onPrimary,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: color.secondary,
                        size: 30,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'mtn',
                          child: Text('MTN'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'telecel',
                          child: Text('Telecel'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'airtel',
                          child: Text('AirtelTigo'),
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
                    if (form.validate()) {}
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mobile money account saved successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (error) {
                    showErrorDialog(context, 'Error: $error');
                  }
                },
                child: Text(
                  'Add Account',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 14,
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
