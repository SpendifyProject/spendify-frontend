import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/transaction_provider.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../widgets/transaction_widget.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key, required this.user});

  final User user;

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
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
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              CupertinoIcons.search,
              color: color.onPrimary,
              size: 20.sp,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: transactionProvider.fetchTransactions(widget.user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          } else {
            List<Transaction> transactions = transactionProvider.transactions;
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 10.w,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                Transaction transaction = transactions[index];
                return TransactionWidget(
                  name: transaction.recipient,
                  category: transaction.category,
                  isDebit: transaction.isDebit,
                  amount: transaction.amount,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
