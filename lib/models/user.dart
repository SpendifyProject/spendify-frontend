import 'package:flutter/material.dart';

class User with ChangeNotifier{
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final double monthlyIncome;
  final String uid;
  final String imagePath;

  User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.monthlyIncome,
    required this.uid,
    required this.imagePath,
  });
}

