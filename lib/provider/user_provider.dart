import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    fullName: 'fullName',
    email: 'email',
    phoneNumber: 'phoneNumber',
    dateOfBirth: DateTime.now(),
    monthlyIncome: 0.0,
    uid: 'uid',
    imagePath: 'https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0',
  );

  User get user => _user;

  Future<void> getUserData(String email) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(email);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        User user = User(
          fullName: userSnapshot['fullName'],
          email: userSnapshot['email'],
          phoneNumber: userSnapshot['phoneNumber'],
          dateOfBirth: userSnapshot['dateOfBirth'],
          monthlyIncome: userSnapshot['monthlyIncome'],
          uid: userSnapshot['uid'],
          imagePath: userSnapshot['imagePath'],
        );
        _user = user;
        notifyListeners();
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> addUser(User newUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set({
        'fullName': newUser.fullName,
        'email': newUser.email,
        'phoneNumber': newUser.phoneNumber,
        'dateOfBirth': newUser.dateOfBirth,
        'monthlyIncome': newUser.monthlyIncome,
        'uid': newUser.uid,
        'imagePath': newUser.imagePath
      });
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
