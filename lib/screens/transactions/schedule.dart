import 'package:flutter/material.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/widgets/amount_text_field.dart';

import '../../const/constants.dart';
import '../../const/sizing_config.dart';
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
            size: 20,
          ),
        ),
        title: Text(
          'Schedule Payments',
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
              height: verticalConverter(context, 390),
              child: Column(
                children: [
                  AmountTextField(
                    controller: amountController,
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
                    labelText: "Recipient",
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
                          lastDate: DateTime(2026),
                          initialDate: DateTime.now(),
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select your next payment date',
                                ),
                              ),
                            );
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
                        size: 30,
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
            height: verticalConverter(context, 30),
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(
              'Save',
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
