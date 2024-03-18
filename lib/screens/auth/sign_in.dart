import 'package:flutter/material.dart';
import 'package:spendify/const/sizing_config.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isHidden = true;

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
            Text(
              'Email Address',
              style: TextStyle(
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email_outlined,
                  color: color.secondary,
                  size: 30,
                ),
              ),
              style: TextStyle(
                color: color.onPrimary,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 15),
            ),
            Text(
              'Password',
              style: TextStyle(
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: isHidden,
              decoration: InputDecoration(
                icon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  child: Icon(
                    isHidden ? Icons.lock_outline : Icons.lock_open_outlined,
                    color: color.secondary,
                    size: 30,
                  ),
                ),
              ),
              style: TextStyle(
                color: color.onPrimary,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: verticalConverter(context, 30),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 14,
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
                  onPressed: (){},
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
