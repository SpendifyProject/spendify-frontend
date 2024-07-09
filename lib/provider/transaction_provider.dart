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

  Transaction get transaction => _transaction;

  List<Transaction> get transactions => _transactions;

  Future<void> fetchTransactions(User user) async {
    try {
      _transactions.clear();
      final transactionSnap = await f.FirebaseFirestore.instance
          .collection('transaction')
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

  Future<void> recordExternalTransaction(
      RecordedTransaction recordedTransaction) async {
    try {
      Transaction transaction = Transaction(
        id: recordedTransaction.id,
        uid: recordedTransaction.uid,
        recipient: recordedTransaction.recipient,
        reference: recordedTransaction.reference,
        date: recordedTransaction.date,
        amount: recordedTransaction.amount,
        paymentMethod: "External Payment",
        isDebit: recordedTransaction.isDebit,
        currency: recordedTransaction.currency,
        category: recordedTransaction.category,
      );
      await saveTransaction(transaction);
      notifyListeners();
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> scheduleTransaction(
      ScheduledTransaction scheduledTransaction) async {
    try {
      await f.FirebaseFirestore.instance
          .collection('scheduled_transactions')
          .doc(scheduledTransaction.id)
          .set({
        'id': scheduledTransaction.id,
        'uid': scheduledTransaction.uid,
        'reference': scheduledTransaction.reference,
        'recipient': scheduledTransaction.recipient,
        'amount': scheduledTransaction.amount,
        'scheduledDate': scheduledTransaction.scheduledDate,
        'category': scheduledTransaction.category,
        'isDebit': scheduledTransaction.isDebit,
        'currency': scheduledTransaction.currency,
      });
      notifyListeners();
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> checkDueTransactions() async {
    final scheduledTransactionsSnap = await f.FirebaseFirestore.instance
        .collection('scheduled_transactions')
        .get();

    final now = DateTime.now();

    for (final doc in scheduledTransactionsSnap.docs) {
      ScheduledTransaction scheduledTransaction = ScheduledTransaction(
        id: doc['id'],
        uid: doc['uid'],
        reference: doc['reference'],
        recipient: doc['recipient'],
        amount: doc['amount'],
        scheduledDate: (doc['scheduledDate'] as f.Timestamp).toDate(),
        category: doc['category'],
        isDebit: doc['isDebit'],
        currency: doc['currency'],
      );

      if (scheduledTransaction.scheduledDate.isBefore(now)) {
        Transaction newTransaction = Transaction(
          id: scheduledTransaction.id,
          uid: scheduledTransaction.uid,
          recipient: scheduledTransaction.recipient,
          reference: scheduledTransaction.reference,
          date: scheduledTransaction.scheduledDate,
          amount: scheduledTransaction.amount,
          paymentMethod: 'Scheduled Payment',
          isDebit: scheduledTransaction.isDebit,
          currency: scheduledTransaction.currency,
          category: scheduledTransaction.category,
        );
        await saveTransaction(newTransaction);
        notifyListeners();

        await f.FirebaseFirestore.instance
            .collection('scheduled_transactions')
            .doc(scheduledTransaction.id)
            .update({
          'scheduledDate': DateTime(
            scheduledTransaction.scheduledDate.year,
            scheduledTransaction.scheduledDate.month + 1,
            scheduledTransaction.scheduledDate.day,
          ),
        });
        notifyListeners();
      }
    }
  }

  Future<List<Transaction>> getMonthlyTransactions(User user) async{
    await fetchTransactions(user);
    List<Transaction> allTransactions = transactions;
    List<Transaction> monthlyTransactions = [];
    DateTime now = DateTime.now();
    for(Transaction transaction in allTransactions){
      if (transaction.date.month == now.month){
        if(monthlyTransactions.contains(transaction)){
          continue;
        }
        else{
          monthlyTransactions.add(transaction);
        }
      }
    }
    notifyListeners();
    return monthlyTransactions;
  }

  Future<List<Transaction>> getTransactionsSortedByCategory(User user, String category) async{
    await fetchTransactions(user);
    List<Transaction> allTransactions = transactions;
    List<Transaction> sortedTransactions = [];
    for(Transaction transaction in allTransactions){
      if (transaction.category == category){
        if(sortedTransactions.contains(transaction)){
          continue;
        }
        else{
          sortedTransactions.add(transaction);
        }
      }
    }
    notifyListeners();
    return sortedTransactions;
  }

  Future<Map<String, double>> getCategoryExpenses(User user, int month) async {
    await fetchTransactions(user);
    List<Transaction> allTransactions = transactions;
    Map<String, double> expenses = {
      'Entertainment': 0.0,
      'Food and Dining': 0.0,
      'Rent and Housing': 0.0,
      'Health and Fitness': 0.0,
      'Shopping': 0.0,
      'Transport': 0.0,
      'Utilities and Repairs': 0.0,
      'Other': 0.0,
    };

    for (Transaction transaction in allTransactions) {
      if (transaction.date.month == month && transaction.isDebit) {
        expenses[transaction.category] = (expenses[transaction.category] ?? 0.0) + transaction.amount;
      }
    }

    notifyListeners();
    return expenses;
  }
}
