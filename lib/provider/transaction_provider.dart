import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../models/user.dart';

class TransactionProvider with ChangeNotifier {
  final Transaction _transaction = Transaction(
    id: "id",
    uid: 'uid',
    recipient: 'recipient',
    reference: 'reference',
    date: DateTime.now(),
    amount: 0.0,
    paymentMethod: 'paymentMethod',
    isDebit: true,
    currency: 'GHS',
    category: 'other',
  );

  final List<Transaction> _transactions = [];
  final List<Transaction> _sortedTransactions = [];

  Transaction get transaction => _transaction;

  List<Transaction> get transactions => _transactions;

  List<Transaction> get sortedTransactions => _sortedTransactions;

  Future<void> fetchTransactions(User user) async {
    try {
      _transactions.clear();
      final transactionSnap = await f.FirebaseFirestore.instance
          .collection('transactions')
          .where('uid', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .get();

      for (final doc in transactionSnap.docs) {
        Transaction transaction = Transaction(
          id: doc['id'] as String,
          uid: doc['uid'] as String,
          recipient: doc['recipient'] as String,
          reference: doc['reference'] as String,
          date: (doc['date'] as f.Timestamp).toDate(),
          amount: doc['amount'] as double,
          paymentMethod: doc['paymentMethod'] as String,
          isDebit: doc['isDebit'] as bool,
          currency: doc['currency'] as String,
          category: doc['category'] as String,
        );
        if (_transactions.contains(transaction)) {
          continue;
        } else {
          _transactions.add(transaction);
        }
        notifyListeners();
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> saveTransaction(Transaction newTransaction) async {
    try {
      await f.FirebaseFirestore.instance
          .collection('transaction')
          .doc(newTransaction.id)
          .set({
        'id': newTransaction.id,
        'uid': newTransaction.uid,
        'recipient': newTransaction.recipient,
        'reference': newTransaction.reference,
        'date': newTransaction.date,
        'amount': newTransaction.amount,
        'paymentMethod': newTransaction.paymentMethod,
        'isDebit': newTransaction.isDebit,
        'currency': newTransaction.currency,
        'category': newTransaction.category,
      });
      notifyListeners();
    } catch (error) {
      log('Error: error');
      rethrow;
    }
  }
}
