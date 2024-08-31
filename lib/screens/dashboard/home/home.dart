import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spendify/models/savings_goal.dart';
import 'package:spendify/models/transaction.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/provider/savings_provider.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/dashboard/home/all_savings_goals.dart';
import 'package:spendify/screens/transactions/transaction_history.dart';
import 'package:spendify/widgets/double_header.dart';
import '../../../provider/transaction_provider.dart';
import '../../../widgets/error_dialog.dart';
import '../../../widgets/profile_widget.dart';
import '../../../widgets/quick_actions.dart';
import '../../../widgets/savings_goal_widget.dart';
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
              child: ProfileWidget(
                imagePath: widget.user.imagePath,
                name: widget.user.fullName,
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
            HomeQuickActions(
              user: widget.user,
            ),
            SizedBox(
              height: 20.h,
            ),
            FutureBuilder(
              future: transactionProvider.fetchTransactions(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        for (int i = 0; i < 5; i++)
                          const TransactionWidgetPlaceholder(),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  showErrorDialog(context, '${snapshot.error}');
                }
                List<Transaction> transactions =
                    transactionProvider.transactions;
                int length = transactions.length;
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
                        height: length >= 5
                            ? 380.h
                            : length == 4
                                ? 350.h
                                : length == 3
                                    ? 300.h
                                    : length == 2
                                        ? 240.h
                                        : 180.h,
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
                  return Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        for (int i = 0; i < 2; i++)
                          const HomeSavingsGoalWidgetPlaceholder(),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  showErrorDialog(context, 'Error: ${snapshot.error}');
                } else {
                  List<SavingsGoal> goals = savingsProvider.savingsGoals;
                  return goals.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          height: goals.length <= 2 ? 180.h : 280.h,
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

class TransactionWidgetPlaceholder extends StatelessWidget {
  const TransactionWidgetPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: color.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}

class HomeSavingsGoalWidgetPlaceholder extends StatelessWidget {
  const HomeSavingsGoalWidgetPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 110.h,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: color.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
