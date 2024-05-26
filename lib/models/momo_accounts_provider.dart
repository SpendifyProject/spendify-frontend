import 'dart:developer'; 

import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:spendify/models/momo_accounts.dart'; 

class MomoAccountProvider with ChangeNotifier { 
  MomoAccount _account = MomoAccount( 
    id: 'id', 
    uid: 'uid', 
    fullName: 'fullName', 
    network: 'network', 
    phoneNumber: 'phoneNumber', 
  ); 

  final List<MomoAccount> _accounts = []; 

  MomoAccount get account => _account; 

  List<MomoAccount> get accounts => _accounts; 

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
        _account = account; 
        _accounts.add(account); 
        notifyListeners(); 
      } 
    } catch (error) { 
      log('Error: $error'); 
    } 
  } 

  Future<void> saveAccount(MomoAccount account) async { 
    try { 
      await FirebaseFirestore.instance.collection('momo_accounts').doc(account.id).set({ 
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
