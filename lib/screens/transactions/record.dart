import 'package:flutter/material.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/widgets/amount_text_field.dart';

import '../../const/constants.dart';
import '../../const/sizing_config.dart';
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
  final formKey = GlobalKey<FormState>();
  String? radioValue;
  bool? isDebit;
  String? selectedCategory;

  @override
  void initState(){
    super.initState();
    amountController = TextEditingController();
    amountController.text = '0.00';
    senderController = TextEditingController();
    recipientController = TextEditingController();
    referenceController = TextEditingController();
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
          horizontal: horizontalConverter(context, 20),
          vertical: verticalConverter(context, 10),
        ),
        children: [
          Form(
            key: formKey,
            child: SizedBox(
              height: verticalConverter(context, 470),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AmountTextField(
                    controller: amountController,
                  ),
                  SizedBox(
                    height: verticalConverter(context, 20),
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
                        width: horizontalConverter(context, 20),
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
                    height: verticalConverter(context, 20),
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
                    height: verticalConverter(context, 20),
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
                    height: verticalConverter(context, 20),
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
            height: verticalConverter(context, 40),
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
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
