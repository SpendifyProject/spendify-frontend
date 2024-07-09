import 'package:flutter/material.dart';
import 'package:spendify/const/constants.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(
      {super.key,
        required this.name,
        required this.category,
        this.icon,
        required this.isDebit,
        required this.amount});

  final String name;
  final String category;
  final String? icon;
  final bool isDebit;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.onSurface,
        radius: 45,
        child: Icon(
          pickCategoryIcon(category),
          size: 30,
          color: color.onPrimary,
        )
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
        'GHc ${formatAmount(amount)}',
        style: TextStyle(
          fontSize: 12,
          color: isDebit ? color.tertiary : color.onTertiary,
        ),
      ),
    );
  }
}
