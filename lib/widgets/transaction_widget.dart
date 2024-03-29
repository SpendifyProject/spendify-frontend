import 'package:flutter/material.dart';

import '../const/sizing_config.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(
      {super.key,
        required this.name,
        required this.category,
        required this.icon,
        required this.isProfit,
        required this.amount});

  final String name;
  final String category;
  final String icon;
  final bool isProfit;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.onBackground,
        radius: 45,
        child: Image.asset(
          'assets/images/$icon.png',
          width: horizontalConverter(context, 25),
          height: verticalConverter(context, 25),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          color: color.onPrimary,
        ),
      ),
      subtitle: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          color: color.secondary,
        ),
      ),
      trailing: Text(
        'GHc${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          color: isProfit ? color.onTertiary : color.tertiary,
        ),
      ),
    );
  }
}
