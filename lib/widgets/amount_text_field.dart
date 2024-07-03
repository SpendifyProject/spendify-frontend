import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({super.key, required this.controller});

  final TextEditingController controller;

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
              fontSize: 11,
              color: color.onSecondary,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const Text(
                'GHc',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(155, 178, 212, 1),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              SizedBox(
                width: 200.w,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: color.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
