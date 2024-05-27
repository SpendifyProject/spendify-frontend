import 'dart:developer'; 
 
import 'package:flutter/material.dart'; 
 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:spendify/models/credit_card.dart'; 
 
class CreditCardProvider with ChangeNotifier { 
  CreditCard _card = CreditCard( 
    fullName: "fullName", 
    cardNumber: 'cardNumber', 
    expiryDate: DateTime.now(), 
    issuer: 'issuer', 
    uid: 'uid', 
    id: 'id', 
  ); 
 
  final List<CreditCard> _cards = []; 
 
  CreditCard get card => _card; 
 
  List<CreditCard> get cards => _cards; 
 
  Future<void> getCardInfo(String uid) async { 
    try { 
      final cardRef = 
      FirebaseFirestore.instance.collection('credit_card').where( 
        'uid', 
        isEqualTo: uid, 
      ); 
      final cardSnapshot = await cardRef.get(); 
      for (final doc in cardSnapshot.docs) { 
        CreditCard card = CreditCard( 
          fullName: doc['fullName'] as String, 
          cardNumber: doc['cardNumber'] as String, 
          expiryDate: doc['expiryDate'] as DateTime, 
          issuer: doc['issuer'] as String, 
          uid: doc['uid'] as String, 
          id: doc['id'] as String, 
        ); 
        _card = card; 
        _cards.add(card); 
        notifyListeners(); 
      } 
    } catch (error) { 
      log('Error: $error'); 
    } 
  } 
 
  Future<void> saveCard(CreditCard card) async{ 
    try{ 
      await FirebaseFirestore.instance.collection('credit_cards').doc(card.id).set({ 
        'fullName': card.fullName, 
        'cardNumber': card.cardNumber, 
        'expiryDate': card.expiryDate, 
        'issuer': card.issuer, 
        'uid': card.uid, 
        'id': card.id, 
      }); 
    } 
    catch(error){ 
      log('Error: $error'); 
    } 
  } 
}