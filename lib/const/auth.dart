import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/provider/user_provider.dart';

import '../models/user.dart' as u;

Future<void> signIn(
  BuildContext context,
  String email,
  String password,
  bool keepMeSignedIn,
) async {
  try {
    // await FirebaseAuth.instance.setPersistence(
    //   keepMeSignedIn ? Persistence.LOCAL : Persistence.NONE,
    // );
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.toLowerCase(),
      password: password,
    );
  } catch (e) {
    rethrow;
  }
}

Future<void> signUp(
  BuildContext context,
  u.User user,
  String password,
  UserProvider userProvider,
  bool keepMeSignedIn,
) async {
  try {
    // await FirebaseAuth.instance.setPersistence(
    //   keepMeSignedIn ? Persistence.LOCAL : Persistence.NONE,
    // );
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email.toLowerCase(),
      password: password,
    );
    userProvider.addUser(user);
  } catch (e) {
    rethrow;
  }
}

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.popAndPushNamed(
    context,
    signInRoute,
  );
}
