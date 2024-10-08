import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/auth/sign_in.dart';
import 'package:spendify/services/auth_service.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:uuid/uuid.dart';

import '../../models/user.dart';
import '../../services/validation_service.dart';
import '../../widgets/error_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController occupationController;
  late TextEditingController dateController;
  late TextEditingController incomeController;
  DateTime? _selectedDate;
  bool isHidden = true;
  bool isChecked = false;
  late UserProvider userProvider;
  final formKey = GlobalKey<FormState>();
  String? nameError;
  String? numberError;
  String? emailError;
  String? incomeError;
  String? dateError;
  String? passwordError;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    occupationController = TextEditingController();
    dateController = TextEditingController();
    incomeController = TextEditingController();
    userProvider = Provider.of<UserProvider>(context, listen: false);
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
              height: 50.h,
            ),
            Text(
              'Sign Up',
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
                height: hasError ? 650.h : 470.h,
                child: Column(
                  children: [
                    CustomAuthTextField(
                      controller: nameController,
                      obscureText: false,
                      errorText: nameError,
                      validator: (value) {
                        nameError = Validator.validateName(value);
                        return nameError;
                      },
                      icon: Icon(
                        Icons.person_outline,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      keyboardType: TextInputType.text,
                      labelText: 'Full Name',
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomAuthTextField(
                      controller: numberController,
                      obscureText: false,
                      errorText: numberError,
                      validator: (value) {
                        numberError = Validator.validatePhoneNumber(value);
                        return numberError;
                      },
                      icon: Icon(
                        Icons.phone_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      keyboardType: TextInputType.number,
                      labelText: 'Number',
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomAuthTextField(
                      controller: emailController,
                      obscureText: false,
                      icon: Icon(
                        Icons.email_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      validator: (value) {
                        emailError = Validator.validateEmail(value);
                        return emailError;
                      },
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email Address',
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
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomAuthTextField(
                      controller: incomeController,
                      obscureText: false,
                      icon: Icon(
                        Icons.monetization_on_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      errorText: incomeError,
                      validator: (value) {
                        incomeError = Validator.validateAmount(value);
                        return incomeError;
                      },
                      keyboardType: TextInputType.number,
                      labelText: 'Monthly Income',
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomAuthTextField(
                      controller: dateController,
                      obscureText: false,
                      errorText: dateError,
                      validator: (value) {
                        if (_selectedDate == null) {
                          dateError = 'Please select your date of birth';
                          return dateError;
                        }
                        return null;
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      suffix: GestureDetector(
                        onTap: () async {
                          await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              barrierDismissible: false,
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: color.primary,
                                    colorScheme:
                                        const ColorScheme.light().copyWith(
                                      primary: color.primary,
                                      onPrimary: color.onPrimary,
                                    ),
                                    dialogBackgroundColor: color.surface,
                                    textTheme: GoogleFonts.poppinsTextTheme(),
                                  ),
                                  child: child!,
                                );
                              }).then((pickedDate) {
                            if (pickedDate == null) {
                              showCustomSnackbar(
                                  context, 'Please select your date of birth');
                              return;
                            } else {
                              setState(() {
                                _selectedDate = pickedDate;
                                dateController.text = formatDate(_selectedDate!);
                              });
                            }
                          });
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          color: color.secondary,
                          size: 30.sp,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      labelText: 'Date of Birth',
                      readOnly: true,
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
                      setState(() {
                        hasError = false;
                      });
                      Uuid uid = const Uuid();
                      User user = User(
                        fullName: nameController.text,
                        email: emailController.text,
                        phoneNumber: numberController.text,
                        dateOfBirth: _selectedDate ?? DateTime.now(),
                        monthlyIncome: double.parse(incomeController.text),
                        uid: uid.v4(),
                        imagePath:
                            'https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0',
                      );
                      await AuthService.signUp(
                        context,
                        user,
                        passwordController.text,
                        userProvider,
                      );
                      setState(() {
                        emailError = null;
                        numberError = null;
                        incomeError = null;
                        nameError = null;
                        passwordError = null;
                        dateError = null;
                      });
                    } else {
                      setState(() {
                        hasError = true;
                      });
                    }
                  } on auth.FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showErrorDialog(context,
                          "Weak password : Password should be above 6 characters");
                    } else if (e.code == 'invalid-password') {
                      showErrorDialog(context, 'Invalid-password');
                    } else if (e.code == 'email-already-in-use') {
                      showErrorDialog(context,
                          'Email belongs to other user: Register with a different email');
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
                  'Sign Up',
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
                  "Already have an account?",
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
                          return const SignIn();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: color.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }
}
