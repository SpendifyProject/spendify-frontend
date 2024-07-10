import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/provider/wallet_provider.dart';
import 'package:spendify/screens/animations/empty.dart';
import 'package:spendify/widgets/double_header.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../models/transaction.dart';
import '../../models/user.dart';
import '../../models/wallet.dart';
import '../../provider/transaction_provider.dart';
import '../../widgets/transaction_widget.dart';
import '../transactions/transaction_history.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key, required this.user});

  final User user;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late WalletProvider _walletProvider;
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.notifications_none,
              color: color.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _walletProvider.fetchWallet(widget.user, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          }
          Wallet wallet = snapshot.data ??
              Wallet(
                uid: 'WALLET_UNAVAILABLE',
                creditCards: [],
                momoAccounts: [],
                monthlyExpenses: 0,
                monthlyIncome: 0,
              );
          if (transactionProvider.transactions.isEmpty) {
            return const Empty(
              text: 'Make some transactions to view this screen',
            );
          } else {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              children: [
                Text(
                  'Monthly Expenses',
                  style: TextStyle(
                    color: color.secondary,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'GHc ${formatAmount(wallet.monthlyExpenses)}',
                  style: TextStyle(
                    color: color.onPrimary,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 400.h,
                  child: CategoryLineChart(user: widget.user),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Category Chart',
                  style: TextStyle(
                    color: color.secondary,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 400.h,
                  child: CategoryPieChart(
                    user: widget.user,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                FutureBuilder(
                  future: transactionProvider.fetchTransactions(widget.user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      showErrorDialog(context, '${snapshot.error}');
                    }
                    List<Transaction> transactions =
                        transactionProvider.transactions;
                    if (transactions.isNotEmpty) {
                      return Column(
                        children: [
                          DoubleHeader(
                            leading: 'Recent Transactions',
                            trailing: 'See All',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Transactions(user: widget.user);
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 400.h,
                            child: ListView.builder(
                              itemCount: transactions.length <= 5
                                  ? transactions.length
                                  : 5,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Transaction transaction = transactions[index];
                                return TransactionWidget(
                                  name: transaction.recipient,
                                  category: transaction.category,
                                  isDebit: transaction.isDebit,
                                  amount: transaction.amount,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CategoryLineChart extends StatelessWidget {
  const CategoryLineChart({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: fetchExpenses(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data as List<Map<String, double>>;
                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final int index = value.toInt();
                            return Container(
                              width: 15.w,
                              height: 10.h,
                              color: categoryColors[index],
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: getSpots(data[0]),
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.blueGrey,
                      ),
                      LineChartBarData(
                        spots: getSpots(data[1]),
                        isCurved: true,
                        barWidth: 3,
                        color: color.primary,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Key',
                style: TextStyle(
                  color: color.onPrimary,
                  fontSize: 15,
                ),
              ),
              buildLegend(context),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<Map<String, double>>> fetchExpenses(BuildContext context) async {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final now = DateTime.now();
    final lastMonth = now.month - 1;
    final currentMonth = now.month;

    final lastMonthExpenses = await transactionProvider.getCategoryExpenses(
      user,
      lastMonth,
    );
    final currentMonthExpenses = await transactionProvider.getCategoryExpenses(
      user,
      currentMonth,
    );

    return [lastMonthExpenses, currentMonthExpenses];
  }

  List<FlSpot> getSpots(Map<String, double> expenses) {
    return categories.asMap().entries.map((entry) {
      int idx = entry.key;
      String category = entry.value;
      return FlSpot(idx.toDouble(), expenses[category] ?? 0.0);
    }).toList();
  }
}

Widget buildLegend(BuildContext context) {
  final color = Theme.of(context).colorScheme;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.asMap().entries.map((entry) {
          int index = entry.key;
          String category = entry.value;
          return Row(
            children: [
              Container(
                width: 10,
                height: 10,
                color: categoryColors[index],
              ),
              SizedBox(width: 8.w),
              Text(
                category,
                style: TextStyle(
                  color: color.onPrimary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
      const Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.line_axis,
                color: color.primary,
              ),
              SizedBox(width: 5.w),
              Text(
                'This Month',
                style: TextStyle(
                  color: color.onPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.line_axis,
                color: Colors.grey,
              ),
              SizedBox(width: 5.w),
              Text(
                'Last Month',
                style: TextStyle(
                  color: color.onPrimary,
                ),
              ),
            ],
          )
        ],
      )
    ],
  );
}

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: fetchExpenses(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                showErrorDialog(context, '${snapshot.error}');
                return const SizedBox();
              } else {
                final data = snapshot.data as List<Map<String, double>>;
                return Row(
                  children: [
                    Expanded(
                      child: buildPieChart(data[1], 'Current Month'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildLegend(context),
        ),
      ],
    );
  }

  Future<List<Map<String, double>>> fetchExpenses(BuildContext context) async {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final now = DateTime.now();
    final lastMonth = now.month - 1;
    final currentMonth = now.month;

    final lastMonthExpenses =
        await transactionProvider.getCategoryExpenses(user, lastMonth);
    final currentMonthExpenses =
        await transactionProvider.getCategoryExpenses(user, currentMonth);

    return [lastMonthExpenses, currentMonthExpenses];
  }

  Widget buildPieChart(Map<String, double> expenses, String title) {
    double total = expenses.values.fold(0, (sum, item) => sum + item);

    List<PieChartSectionData> sections = expenses.entries.map((entry) {
      final int index = categories.indexOf(entry.key);
      final double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: categoryColors[index],
        value: entry.value,
        title: '${percentage.roundToDouble()}%',
      );
    }).toList();

    return Expanded(
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget buildLegend(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: categories.asMap().entries.map((entry) {
        int index = entry.key;
        String category = entry.value;
        return Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: categoryColors[index],
            ),
            SizedBox(width: 8.w),
            Text(
              category,
              style: TextStyle(
                color: color.onPrimary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
