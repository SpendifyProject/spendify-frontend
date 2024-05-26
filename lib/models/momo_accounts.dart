import 'package:flutter/material.dart';

class MomoAccount with ChangeNotifier {
  final String id;
  final String uid;
  final String fullName;
  final String network;
  final String phoneNumber;

  MomoAccount({
    required this.id,
    required this.uid,
    required this.fullName,
    required this.network,
    required this.phoneNumber,
  });
}
