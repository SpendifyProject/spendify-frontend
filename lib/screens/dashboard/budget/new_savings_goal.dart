import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/models/savings_goal.dart';
import 'package:spendify/provider/savings_provider.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../const/constants.dart';
import '../../animations/done.dart';
import '../dashboard.dart';

class NewSavingsGoal extends StatefulWidget {
  const NewSavingsGoal({super.key, required this.uid});

  final String uid;

  @override
  State<NewSavingsGoal> createState() => _NewSavingsGoalState();
}

class _NewSavingsGoalState extends State<NewSavingsGoal> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController goalController;
  late TextEditingController targetController;
  late TextEditingController deadlineController;
  DateTime? _selectedDate;
  late SavingsProvider savingsProvider;

  @override
  void initState() {
    super.initState();
    goalController = TextEditingController();
    targetController = TextEditingController();
    deadlineController = TextEditingController();
    savingsProvider = Provider.of<SavingsProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    goalController.dispose();
    targetController.dispose();
    deadlineController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'New Savings Goal',
          style: TextStyle(
            fontSize: 18.sp,
            color: color.onPrimary,
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
                  controller: goalController,
                  obscureText: false,
                  icon: Icon(
                    Icons.description_outlined,
                    color: color.secondary,
                    size: 30.sp,
                  ),
                  keyboardType: TextInputType.text,
                  labelText: 'What are you saving for?',
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  controller: targetController,
                  obscureText: false,
                  icon: Icon(
                    Icons.attach_money,
                    color: color.secondary,
                    size: 30.sp,
                  ),
                  keyboardType: TextInputType.text,
                  labelText: 'How much money do you need?',
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  controller: deadlineController,
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
                          barrierDismissible: false,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: color.primary,
                                colorScheme: const ColorScheme.light().copyWith(
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
                              content: Text('Please select your deadline'),
                            ),
                          );
                          return;
                        } else {
                          setState(() {
                            _selectedDate = pickedDate;
                            deadlineController.text =
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
                  labelText: "When's your deadline",
                  readOnly: true,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        final form = formKey.currentState!;
                        if (form.validate()) {}

                        SavingsGoal goal = SavingsGoal(
                          id: const Uuid().v4(),
                          uid: widget.uid,
                          goal: goalController.text,
                          targetAmount: double.parse(targetController.text),
                          deadline: _selectedDate!,
                          currentAmount: 0,
                        );

                        savingsProvider.createGoal(goal);
                        showCustomSnackbar(context, 'New savings goal created');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DoneScreen(
                                nextPage: Dashboard(
                                  email: firebaseEmail,
                                ),
                              );
                            },
                          ),
                        );
                      } catch (error) {
                        showErrorDialog(context, 'Error: $error');
                      }
                    },
                    child: Text(
                      'Create',
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
        ],
      ),
    );
  }
}
