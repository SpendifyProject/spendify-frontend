import 'package:flutter/material.dart'; 
 
class CreditCard with ChangeNotifier { 
  final String fullName; 
  final String cardNumber; 
  final DateTime expiryDate; 
  final String issuer; 
  final String uid; 
  final String id; 
 
  CreditCard({ 
    required this.fullName, 
    required this.cardNumber, 
    required this.expiryDate, 
    required this.issuer, 
    required this.uid, 
    required this.id, 
  }); 
}