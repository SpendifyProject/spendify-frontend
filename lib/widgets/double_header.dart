import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoubleHeader extends StatelessWidget {
  const DoubleHeader(
      {super.key,
      required this.leading,
      required this.trailing,
      this.routeName});

  final String leading;
  final String trailing;
  final String? routeName;

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
        GestureDetector(
          onTap: () {
            if (routeName != null) {
              Navigator.pushNamed(
                context,
                routeName!,
              );
            } else {
              null;
            }
          },
          child: Text(
            trailing,
            style: TextStyle(
              fontSize: 14,
              color: color.primary,
            ),
          ),
        )
      ],
    );
  }
}
