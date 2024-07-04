import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendify/models/credit_card.dart';
import 'package:spendify/models/momo_accounts.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/models/wallet.dart';
import 'package:spendify/models/transaction.dart' as t;
import 'package:spendify/provider/transaction_provider.dart';

late TransactionProvider _transactionProvider;

class WalletProvider with ChangeNotifier {
  Wallet _wallet = Wallet(
    uid: "uid",
    creditCards: <CreditCard>[],
    momoAccounts: <MomoAccount>[],
    monthlyIncome: 0,
    monthlyExpenses: 0,
  );

  Wallet get wallet => _wallet;

  Future<Wallet> fetchWallet(User user, BuildContext context) async {
    _transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    List<t.Transaction> monthlyTransactions = await _transactionProvider.getMonthlyTransactions(user);
    double monthlyIncome = user.monthlyIncome;
    double monthlyExpenses = 0;
    for(t.Transaction transaction in monthlyTransactions){
      if(transaction.isDebit){
        monthlyExpenses += transaction.amount;
      }
      else{
        monthlyIncome += transaction.amount;
      }
    }
    _wallet.creditCards.clear();
    _wallet.momoAccounts.clear();
    _wallet.uid = user.uid;
    await getCardInfo(user.uid);
    await getAccountInfo(user.uid);
    _wallet = Wallet(
      uid: user.uid,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      creditCards: _wallet.creditCards,
      momoAccounts: _wallet.momoAccounts,
    );
    return _wallet;
  }

  Future<void> getCardInfo(String uid) async {
    try {
      final cardRef =
          FirebaseFirestore.instance.collection('credit_cards').where(
                'uid',
                isEqualTo: uid,
              );
      final cardSnapshot = await cardRef.get();
      for (final doc in cardSnapshot.docs) {
        CreditCard card = CreditCard(
          fullName: doc['fullName'] as String,
          cardNumber: doc['cardNumber'] as String,
          expiryDate: (doc['expiryDate'] as Timestamp).toDate(),
          issuer: doc['issuer'] as String,
          uid: doc['uid'] as String,
          id: doc['id'] as String,
        );
        if (_wallet.creditCards.contains(card)) {
          continue;
        } else {
          _wallet.creditCards.add(card);
        }
        notifyListeners();
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> saveCard(CreditCard card) async {
    try {
      await FirebaseFirestore.instance
          .collection('credit_cards')
          .doc(card.id)
          .set({
        'fullName': card.fullName,
        'cardNumber': card.cardNumber,
        'expiryDate': card.expiryDate,
        'issuer': card.issuer,
        'uid': card.uid,
        'id': card.id,
      });
    } catch (error) {
      log('Error: $error');
    }
  }

  Future<void> getAccountInfo(String uid) async {
    try {
      final accountRef =
          FirebaseFirestore.instance.collection('momo_accounts').where(
                'uid',
                isEqualTo: uid,
              );
      final accountSnapshot = await accountRef.get();
      for (final doc in accountSnapshot.docs) {
        MomoAccount account = MomoAccount(
          id: doc['id'] as String,
          uid: doc['uid'] as String,
          fullName: doc['fullName'] as String,
          network: doc['network'] as String,
          phoneNumber: doc['phoneNumber'] as String,
        );
        if (_wallet.momoAccounts.contains(account)) {
          continue;
        } else {
          _wallet.momoAccounts.add(account);
        }
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> saveAccount(MomoAccount account) async {
    try {
      await FirebaseFirestore.instance
          .collection('momo_accounts')
          .doc(account.id)
          .set({
        'id': account.id,
        'uid': account.uid,
        'fullName': account.fullName,
        'network': account.network,
        'phoneNumber': account.phoneNumber,
      });
    } catch (error) {
      log('Error: $error');
    }
  }
}
