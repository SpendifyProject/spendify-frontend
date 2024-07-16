import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:spendify/models/savings_goal.dart';
import '../models/user.dart';

class SavingsProvider with ChangeNotifier {
  final SavingsGoal _goal = SavingsGoal(
    id: "id",
    uid: "uid",
    goal: "goal",
    targetAmount: 0.0,
    deadline: DateTime.now(),
  );

  final List<SavingsGoal> _goals = [];

  SavingsGoal get savingsGoal => _goal;

  List<SavingsGoal> get savingsGoals => _goals;

  Future<void> createGoal(SavingsGoal goal) async {
    try {
      await FirebaseFirestore.instance
          .collection('savings_goals')
          .doc(goal.id)
          .set({
        'id': goal.id,
        'uid': goal.uid,
        'goal': goal.goal,
        'targetAmount': goal.targetAmount,
        'currentAmount': goal.currentAmount,
        'deadline': goal.deadline,
      });
      notifyListeners();
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> fetchGoals(User user) async {
    try {
      _goals.clear();
      final goalSnap = await FirebaseFirestore.instance
          .collection('savings_goals')
          .where('uid', isEqualTo: user.uid)
          .get();
      for (final doc in goalSnap.docs) {
        SavingsGoal goal = SavingsGoal(
          id: doc['id'] as String,
          uid: doc['uid'] as String,
          goal: doc['goal'] as String,
          targetAmount: doc['targetAmount'] as double,
          deadline: (doc['deadline'] as Timestamp).toDate(),
        );
        if (_goals.contains(goal)) {
          continue;
        } else {
          _goals.add(goal);
        }
        notifyListeners();
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
