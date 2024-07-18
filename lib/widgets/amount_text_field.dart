import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.controller,
    this.errorText,
    required this.validator,
  });

  final TextEditingController controller;
  final String? errorText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      height: 130.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.secondary,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 10.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Amount',
            style: TextStyle(
              fontSize: 11.sp,
              color: color.onSecondary,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Text(
                'GHc',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(155, 178, 212, 1),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              SizedBox(
                width: 200.w,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  validator: validator,
                  style: TextStyle(
                    color: color.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: errorText,
                    errorMaxLines: 2,
                    errorStyle: TextStyle(
                      color: color.tertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
