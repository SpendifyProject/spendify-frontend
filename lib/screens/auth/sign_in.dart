import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/const/auth.dart';
import 'package:spendify/screens/auth/sign_up.dart';
import 'package:spendify/services/validation_service.dart';

import '../../widgets/custom_auth_text_field.dart';
import '../../widgets/error_dialog.dart';

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
  String? errorText;
  String? passwordError;

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
          horizontal: 20.w,
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 149.h,
            ),
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 32.sp,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Form(
              key: formKey,
              child: SizedBox(
                height: 200.h,
                child: Column(
                  children: [
                    CustomAuthTextField(
                      controller: emailController,
                      obscureText: false,
                      icon: Icon(
                        Icons.email_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email Address',
                      errorText: errorText,
                      validator: (email) {
                        errorText = Validator.validateEmail(email);
                        return errorText;
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomAuthTextField(
                      controller: passwordController,
                      obscureText: isHidden,
                      errorText: passwordError,
                      validator: (value) {
                        passwordError = Validator.validatePassword(value);
                        return passwordError;
                      },
                      icon: Icon(
                        Icons.lock_outline,
                        color: color.secondary,
                        size: 30.sp,
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
                          size: 30.sp,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      labelText: 'Password',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      await signIn(
                        context,
                        emailController.text,
                        passwordController.text,
                        isChecked,
                      );
                      setState(() {
                        errorText = null;
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showErrorDialog(context, 'User not found');
                    } else if (e.code == 'wrong-password') {
                      showErrorDialog(context, 'Wrong password');
                    } else if (e.code == 'invalid-credential') {
                      showErrorDialog(context,
                          'Incorrect credentials. Check your email and password');
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "I'm a new user.",
                  style: TextStyle(
                    color: color.secondary,
                    fontSize: 14.sp,
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
                      fontSize: 14.sp,
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
