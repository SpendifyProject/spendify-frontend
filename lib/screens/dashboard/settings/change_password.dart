import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_auth_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController passwordController;
  late TextEditingController confirmController;
  bool isHidden1 = true;
  bool isHidden2 = true;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          10.w,
          20.h,
          10.w,
          0,
        ),
        child: ListView(
          children: [
            CustomAuthTextField(
              controller: passwordController,
              obscureText: isHidden1,
              icon: Icon(
                Icons.lock_outline,
                color: color.secondary,
                size: 30,
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    isHidden1 = !isHidden1;
                  });
                },
                child: Icon(
                  isHidden1
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: color.secondary,
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.text,
              labelText: 'New Password',
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomAuthTextField(
              controller: confirmController,
              obscureText: isHidden2,
              icon: Icon(
                Icons.lock_outline,
                color: color.secondary,
                size: 30,
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    isHidden2 = !isHidden2;
                  });
                },
                child: Icon(
                  isHidden2
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: color.secondary,
                  size: 30,
                ),
              ),
              keyboardType: TextInputType.text,
              labelText: 'Confirm New Password',
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Both Passwords Must Match',
              style: TextStyle(
                color: color.secondary,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
