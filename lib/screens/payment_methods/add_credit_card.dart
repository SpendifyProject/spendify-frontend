import 'package:flutter/material.dart';
import 'package:spendify/const/sizing_config.dart';

import '../../widgets/custom_auth_text_field.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    dateController = TextEditingController();
    issuerController = TextEditingController();
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
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.secondary,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalConverter(context, 20),
          horizontal: horizontalConverter(context, 10),
        ),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: CustomAuthTextField(
                controller: nameController,
                obscureText: false,
                icon: Icon(
                  Icons.person_outline,
                  color: color.secondary,
                  size: 30,
                ),
                keyboardType: TextInputType.text,
                labelText: 'Cardholder Full Name',
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 20),
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
              labelText: 'Card Number',
            ),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            CustomAuthTextField(
              controller: dateController,
              obscureText: false,
              icon: Icon(
                Icons.date_range_outlined,
                color: color.secondary,
                size: 30,
              ),
              suffix: GestureDetector(
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2040),
                    initialDate: DateTime.now(),
                  ).then((pickedDate) {
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
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.text,
              labelText: 'Expiry Date',
              readOnly: true,
            ),
            SizedBox(
              height: verticalConverter(context, 20),
            ),
            CustomAuthTextField(
              controller: issuerController,
              obscureText: false,
              icon: Icon(
                Icons.business_center_outlined,
                color: color.secondary,
                size: 30,
              ),
              suffix: PopupMenuButton(
                onSelected: (String value) {
                  setState(() {
                    _selectedIssuer = value;
                    issuerController.text = _selectedIssuer;
                  });
                },
                color: color.background,
                icon: Icon(
                  Icons.edit_outlined,
                  color: color.secondary,
                  size: 30,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Mastercard',
                    child: Text('Mastercard'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Visa',
                    child: Text('Visa'),
                  ),
                ],
              ),
              keyboardType: TextInputType.text,
              labelText: 'Issuer',
              readOnly: true,
            ),
            SizedBox(
              height: verticalConverter(context, 40),
            ),
            Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Add Card',
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
