import 'package:flutter/material.dart';

import '../const/sizing_config.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      height: verticalConverter(context, 130),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.secondary,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalConverter(context, 20),
        horizontal: horizontalConverter(context, 10),
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
            height: verticalConverter(context, 10),
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
                width: horizontalConverter(context, 15),
              ),
              SizedBox(
                width: horizontalConverter(context, 200),
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
