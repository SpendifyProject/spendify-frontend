import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendify/const/routes.dart';
import 'package:spendify/provider/user_provider.dart';

import '../models/user.dart' as u;
import '../screens/animations/done.dart';
import '../screens/dashboard/dashboard.dart';

class AuthService {
  static Future<void> signIn(
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DoneScreen(
              nextPage: Dashboard(
                email: email,
              ),
            );
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signUp(
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DoneScreen(
              nextPage: Dashboard(
                email: user.email,
              ),
            );
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(
      context,
      signInRoute,
    );
  }

  static Future<void> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);

    await signOut(context);
  }
}
