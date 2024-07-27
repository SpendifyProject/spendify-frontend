import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/models/savings_goal.dart';
import 'package:spendify/provider/savings_provider.dart';
import 'package:spendify/screens/animations/empty.dart';
import 'package:spendify/screens/dashboard/dashboard.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../../models/user.dart';
import '../../../widgets/savings_goal_widget.dart';

class AllSavingsGoals extends StatefulWidget {
  const AllSavingsGoals({super.key, required this.user});

  final User user;

  @override
  State<AllSavingsGoals> createState() => _AllSavingsGoalsState();
}

class _AllSavingsGoalsState extends State<AllSavingsGoals> {
  late SavingsProvider savingsProvider;

  @override
  void initState() {
    super.initState();
    savingsProvider = Provider.of<SavingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            popAndPushReplacement(
              context,
              Dashboard(email: firebaseEmail),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Savings Goals',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: FutureBuilder(
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
                ? const Empty(
                    text: 'Set new savings goals in the budget page',
                  )
                : ListView.builder(
                    itemCount: goals.length,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 20.w,
                    ),
                    itemBuilder: (context, index) {
                      SavingsGoal goal = goals[index];
                      return SavingsGoalWidget(
                        savingsGoal: goal,
                        savingsProvider: savingsProvider,
                        user: widget.user,
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
