import 'package:flutter/material.dart';

class SavingsGoal with ChangeNotifier {
  final String id;
  final String uid;
  final String goal;
  final double targetAmount;
  double currentAmount;
  final DateTime deadline;

  SavingsGoal({
    required this.id,
    required this.uid,
    required this.goal,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
  });
}

class EmergencyFund with ChangeNotifier {
  final String id;
  final String uid;
  double currentAmount;

  EmergencyFund({
    required this.id,
    required this.uid,
    this.currentAmount = 0.0,
  });
}
