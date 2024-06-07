import 'package:flutter/material.dart';

class Transaction with ChangeNotifier {
  final String id;
  final String uid;
  final String recipient;
  final String reference;
  final DateTime date;
  final double amount;
  final String paymentMethod;
  final bool isDebit;
  final String currency;

  Transaction({
    required this.id,
    required this.uid,
    required this.recipient,
    required this.reference,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    required this.isDebit,
    required this.currency,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      uid: json['uid'],
      recipient: json['recipient'],
      reference: json['reference'],
      date: json['date'],
      amount: json['amount'],
      paymentMethod: json['paymentMethod'],
      isDebit: json['isDebit'],
      currency: json['currency']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'recipient': recipient,
      'reference': reference,
      'date': date,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'isDebit': isDebit,
      'currency': currency,
    };
  }

  Map<String, dynamic> toPaystackJson(String email) {
    return {
      'amount': amount,
      'reference': reference,
      'currency': currency,
      'email': email,
    };
  }
}
