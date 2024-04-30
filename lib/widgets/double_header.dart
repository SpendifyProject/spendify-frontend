import 'package:flutter/material.dart';

class DoubleHeader extends StatelessWidget {
  const DoubleHeader(
      {super.key, required this.leading, required this.trailing});

  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          leading,
          style: TextStyle(
            fontSize: 18,
            color: color.onPrimary,
          ),
        ),
        Text(
          trailing,
          style: TextStyle(
            fontSize: 14,
            color: color.primary,
          ),
        )
      ],
    );
  }
}
