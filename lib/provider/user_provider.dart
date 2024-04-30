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
    imagePath:
        'https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0',
  );

  User get user => _user;

  Future<void> getUserData(String email) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').where(
            'email',
            isEqualTo: email,
          );
      final userSnapshot = await userRef.get();
      for (final doc in userSnapshot.docs) {
        User user = User(
          fullName: doc['fullName'] as String,
          email: doc['email'] as String,
          phoneNumber: doc['phoneNumber'] as String,
          dateOfBirth: (doc['dateOfBirth'] as Timestamp).toDate(),
          monthlyIncome: doc['monthlyIncome'] as double,
          uid: doc['uid'] as String,
          imagePath: doc['imagePath'] as String,
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
        'email': newUser.email.toLowerCase(),
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
