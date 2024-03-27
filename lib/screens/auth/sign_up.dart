import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/auth.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/screens/animations/done.dart';
import 'package:spendify/screens/auth/sign_in.dart';
import 'package:spendify/screens/home.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:uuid/uuid.dart';

import '../../const/sizing_config.dart';
import '../../models/user.dart';

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
          horizontal: horizontalConverter(context, 20),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: verticalConverter(context, 50),
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                color: color.onPrimary,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            CustomAuthTextField(
              controller: nameController,
              obscureText: false,
              icon: Icon(
                Icons.person_outline,
                color: color.secondary,
                size: 30,
              ),
              keyboardType: TextInputType.text,
              labelText: 'Full Name',
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            CustomAuthTextField(
              controller: numberController,
              obscureText: false,
              icon: Icon(
                Icons.phone_outlined,
                color: color.secondary,
                size: 30,
              ),
              keyboardType: TextInputType.number,
              labelText: 'Number',
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            CustomAuthTextField(
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
              height: verticalConverter(context, 15),
            ),
            CustomAuthTextField(
              controller: incomeController,
              obscureText: false,
              icon: Icon(
                Icons.monetization_on_outlined,
                color: color.secondary,
                size: 30,
              ),
              keyboardType: TextInputType.number,
              labelText: 'Monthly Income',
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            CustomAuthTextField(
              controller: dateController,
              obscureText: false,
              icon: Icon(
                Icons.date_range_outlined,
                color: color.secondary,
                size: 30,
              ),
              suffix: GestureDetector(
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  ).then((pickedDate) {
                    if (pickedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select your date of birth'),
                        ),
                      );
                      return;
                    } else {
                      setState(() {
                        _selectedDate = pickedDate;
                        dateController.text =
                            '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}';
                      });
                    }
                  });
                },
                child: Icon(
                  Icons.edit_outlined,
                  color: color.secondary,
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.text,
              labelText: 'Date of Birth',
              readOnly: true,
            ),
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
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
                  signUp(
                    context,
                    user,
                    passwordController.text,
                    userProvider,
                    isChecked,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const DoneScreen(
                          nextPage: Home(),
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Sign Up',
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
                  "Already have an account",
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
                          return const SignIn();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: color.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: verticalConverter(context, 100),
            ),
          ],
        ),
      ),
    );
  }
}
