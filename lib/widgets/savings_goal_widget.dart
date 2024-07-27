import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/constants.dart';
import '../models/savings_goal.dart';
import '../models/user.dart';
import '../provider/savings_provider.dart';
import '../screens/dashboard/home/all_savings_goals.dart';
import '../services/validation_service.dart';
import 'custom_auth_text_field.dart';

class SavingsGoalWidget extends StatefulWidget {
  const SavingsGoalWidget({
    super.key,
    required this.savingsProvider,
    required this.savingsGoal,
    required this.user,
  });

  final SavingsGoal savingsGoal;
  final SavingsProvider savingsProvider;
  final User user;

  @override
  State<SavingsGoalWidget> createState() => _SavingsGoalWidgetState();
}

class _SavingsGoalWidgetState extends State<SavingsGoalWidget> {
  TextEditingController amountController = TextEditingController();
  String? amountError;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 176.h,
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 20.w,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(55, 124, 200, 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.savingsGoal.goal,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      getTimeLeft(widget.savingsGoal.deadline),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                LinearProgressIndicator(
                  minHeight: 4.h,
                  borderRadius: BorderRadius.circular(2.r),
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  value: widget.savingsGoal.currentAmount > 0
                      ? widget.savingsGoal.currentAmount /
                      widget.savingsGoal.targetAmount
                      : 0.01,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                            'GHc ${formatAmount(widget.savingsGoal.currentAmount)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                            '  of GHc ${formatAmount(widget.savingsGoal.targetAmount)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${widget.savingsGoal.currentAmount > 0 ? ((widget.savingsGoal.currentAmount / widget.savingsGoal.targetAmount) * 100).ceil() : 0}%',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(-20.w, 10.h),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: color.surface,
                        elevation: 10,
                        child: SizedBox(
                          height: 200.h,
                          width: 200.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Text(
                                    'How much have you added to the savings?',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: color.secondary,
                                    ),
                                  ),
                                  CustomAuthTextField(
                                    controller: amountController,
                                    obscureText: false,
                                    errorText: amountError,
                                    validator: (value) {
                                      amountError =
                                          Validator.validateAmount(value);
                                      return amountError;
                                    },
                                    icon: Icon(
                                      Icons.monetization_on_outlined,
                                      size: 30.sp,
                                      color: color.secondary,
                                    ),
                                    keyboardType:
                                    const TextInputType.numberWithOptions(),
                                    labelText: '',
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        widget.savingsProvider
                                            .updateCurrentAmount(
                                          widget.savingsGoal.id,
                                          widget.savingsGoal.currentAmount,
                                          double.parse(amountController.text),
                                        );
                                        setState(() {
                                          amountError = null;
                                        });
                                        popAndPushReplacement(
                                          context,
                                          AllSavingsGoals(user: widget.user),
                                        );
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.r,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30.sp,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class HomeSavingsGoalWidget extends StatelessWidget {
  const HomeSavingsGoalWidget(
      {super.key,
        required this.goal,
        required this.targetAmount,
        required this.currentAmount});

  final String goal;
  final double targetAmount;
  final double currentAmount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: 156.w,
      height: 90.h,
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        color: color.onSurface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal,
            style: TextStyle(
              color: color.onSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'GHc ${formatAmount(targetAmount)}',
            style: TextStyle(
              color: color.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            backgroundColor: color.surface,
            color: color.primary,
            value: currentAmount > 0 ? currentAmount / targetAmount : 0.01,
            borderRadius: BorderRadius.circular(7.r),
            minHeight: 7.h,
          ),
        ],
      ),
    );
  }
}
