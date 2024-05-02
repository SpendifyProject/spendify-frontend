import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendify/const/auth.dart';
import 'package:spendify/const/sizing_config.dart';
import 'package:spendify/screens/auth/sign_up.dart';
import 'package:spendify/screens/onboarding/dashboard.dart';

import '../../widgets/custom_auth_text_field.dart';
import '../../widgets/error_dialog.dart';
import '../animations/done.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isHidden = true;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalConverter(context, 20),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: verticalConverter(context, 149),
            ),
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 32,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Form(
              key: formKey,
              child: CustomAuthTextField(
                controller: emailController,
                obscureText: false,
                icon: Icon(
                  Icons.email_outlined,
                  color: color.secondary,
                  size: 30,
                ),
                keyboardType: TextInputType.emailAddress,
                labelText: 'Email Address',
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            CustomAuthTextField(
              controller: passwordController,
              obscureText: isHidden,
              icon: Icon(
                Icons.lock_outline,
                color: color.secondary,
                size: 30,
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
                child: Icon(
                  isHidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: color.secondary,
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.text,
              labelText: 'Password',
            ),
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  try {
                    final form = formKey.currentState!;
                    if (form.validate()) {}
                    signIn(
                      context,
                      emailController.text,
                      passwordController.text,
                      isChecked,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DoneScreen(
                            nextPage: Dashboard(
                              email: emailController.text,
                            ),
                          );
                        },
                      ),
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
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "I'm a new user.",
                  style: TextStyle(
                    color: color.secondary,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignUp();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: color.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
