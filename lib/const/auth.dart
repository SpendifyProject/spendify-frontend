import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/widgets/error_dialog.dart';

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
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showErrorDialog(context, 'User not found');
    } else if (e.code == 'wrong-password') {
      showErrorDialog(context, 'Wrong password');
    } else {
      showErrorDialog(context, 'Error: $e');
    }
  } catch (e) {
    showErrorDialog(context, 'Error: $e');
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
      email: user.email,
      password: password,
    );
    userProvider.addUser(user);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showErrorDialog(
          context, "Weak password : Password should be above 6 characters");
    } else if (e.code == 'invalid-password') {
      showErrorDialog(context, 'Invalid-password');
    } else if (e.code == 'email-already-in-use') {
      showErrorDialog(context,
          'Email belongs to other user: Register with a different email');
    } else {
      showErrorDialog(context, 'Error: $e');
    }
  } catch (e) {
    showErrorDialog(context, 'Error: $e');
  }
}
