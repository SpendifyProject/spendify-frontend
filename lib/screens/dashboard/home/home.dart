import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/models/savings_goal.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/savings_provider.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/dashboard/home/all_savings_goals.dart';
import 'package:spendify/screens/transactions/record.dart';
import 'package:spendify/screens/transactions/schedule.dart';
import 'package:spendify/screens/transactions/send_money.dart';
import 'package:spendify/screens/transactions/transaction_history.dart';
import 'package:spendify/widgets/double_header.dart';

import 'package:spendify/const/routes.dart';
import '../../../provider/transaction_provider.dart';
import '../../../widgets/error_dialog.dart';
import '../../../widgets/transaction_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});
  final User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;
  late TransactionProvider transactionProvider;
  late SavingsProvider savingsProvider;
  bool isLoading = true;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    savingsProvider = Provider.of<SavingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    isLoading = false;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        child: ListView(
          children: [
            Skeletonizer(
              enabled: isLoading,
              child: ListTile(
                isThreeLine: true,
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, profileRoute);
                  },
                  child: ClipOval(
                    child: Image.network(
                      widget.user.imagePath,
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                ),
                title: Text(
                  'Welcome,',
                  style: TextStyle(
                    color: color.secondary,
                    fontSize: 12.sp,
                  ),
                ),
                subtitle: Text(
                  widget.user.fullName,
                  style: TextStyle(
                    color: color.onPrimary,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 90.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TransactionButton(
                      iconData: Icons.arrow_upward,
                      label: 'Send',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SendMoney(user: widget.user);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TransactionButton(
                      iconData: Icons.schedule_outlined,
                      label: 'Schedule',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ScheduleTransaction(
                                user: widget.user,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TransactionButton(
                      iconData: Icons.add,
                      label: 'Record',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecordTransaction(
                                user: widget.user,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                        leading: 'Transactions',
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
                        height: 320.h,
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
            FutureBuilder(
              future: savingsProvider.fetchGoals(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  showErrorDialog(context, 'Error: ${snapshot.error}');
                } else {
                  List<SavingsGoal> goals = savingsProvider.savingsGoals;
                  return goals.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          height: goals.length <= 2 ? 180.h :280.h,
                          child: Column(
                            children: [
                              DoubleHeader(
                                leading: 'Savings',
                                trailing: 'See All',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AllSavingsGoals(
                                          user: widget.user,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Expanded(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      goals.length <= 4 ? goals.length : 4,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 10.w,
                                    mainAxisExtent: 110.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    SavingsGoal goal = goals[index];
                                    return HomeSavingsGoalWidget(
                                      goal: goal.goal,
                                      targetAmount: goal.targetAmount,
                                      currentAmount: goal.currentAmount,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionButton extends StatelessWidget {
  const TransactionButton(
      {super.key, required this.iconData, required this.label, this.onTap});

  final IconData iconData;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color.onSurface,
            radius: 27.r,
            child: Icon(
              iconData,
              color: color.onPrimary,
              size: 30.sp,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 13.sp,
          ),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ],
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
          SizedBox(
            height: 15.h,
          )
        ],
      ),
    );
  }
}
