import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/services/auth_service.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/error_dialog.dart';

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
  final formKey = GlobalKey<FormState>();
  String? oldError;
  String? newError;

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
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: color.onPrimary,
            size: 20.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          10.w,
          20.h,
          10.w,
          0,
        ),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomAuthTextField(
                  controller: passwordController,
                  obscureText: isHidden1,
                  errorText: oldError,
                  validator: (value){
                    oldError = Validator.validatePassword(value);
                    return oldError;
                  },
                  icon: Icon(
                    Icons.lock_outline,
                    color: color.secondary,
                    size: 30.sp,
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
                  labelText: 'Old Password',
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  controller: confirmController,
                  obscureText: isHidden2,
                  errorText: newError,
                  validator: (value){
                    if(value == passwordController.text){
                      newError = 'Both passwords must not match';
                      return newError;
                    }
                    newError = Validator.validatePassword(value);
                    return newError;
                  },
                  icon: Icon(
                    Icons.lock_outline,
                    color: color.secondary,
                    size: 30.sp,
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
                      size: 30.sp,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  labelText: 'New Password',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Both Passwords Must Not Match',
            style: TextStyle(
              color: color.secondary,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async{
                try{
                  if(formKey.currentState!.validate()){
                    String oldPassword = passwordController.text;
                    String newPassword = confirmController.text;
                    setState(() {
                      oldError = null;
                      newError = null;
                    });
                    await AuthService.changePassword(oldPassword, newPassword, context);
                  }
                }
                catch(error){
                  showErrorDialog(context, 'Error: $error');
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
