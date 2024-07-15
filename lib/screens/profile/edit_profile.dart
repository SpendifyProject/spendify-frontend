import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:spendify/widgets/error_dialog.dart';

import '../../models/user.dart';
import '../../widgets/custom_auth_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserProvider userProvider;
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
  final formKey = GlobalKey<FormState>();
  bool isLoading = true;
  String email = auth.FirebaseAuth.instance.currentUser!.email.toString();

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
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
      body: FutureBuilder(
        future: userProvider.getUserData(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading = true;
            return const SizedBox();
          } else if (snapshot.hasError) {
            showErrorDialog(context, 'Error: ${snapshot.error}');
          } else {
            User user = userProvider.user;
            nameController.text = user.fullName;
            numberController.text = user.phoneNumber;
            emailController.text = user.email;
            incomeController.text = user.monthlyIncome.toString();
            _selectedDate = user.dateOfBirth;
            dateController.text =
                '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}';
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25.h,
                horizontal: 10.w,
              ),
              child: ListView(
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        user.imagePath,
                        width: 90.w,
                        height: 90.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Form(
                    key: formKey,
                    child: CustomAuthTextField(
                      controller: nameController,
                      obscureText: false,
                      icon: Icon(
                        Icons.person_outline,
                        color: color.secondary,
                        size: 30.sp,
                      ),
                      keyboardType: TextInputType.text,
                      labelText: 'Full Name',
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomAuthTextField(
                    controller: numberController,
                    obscureText: false,
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
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email Address',
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
                    keyboardType: TextInputType.number,
                    labelText: 'Monthly Income',
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomAuthTextField(
                    controller: dateController,
                    obscureText: false,
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
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            showCustomSnackbar(context, 'Please select your date of birth',);
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
                        size: 30.sp,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    labelText: 'Date of Birth',
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          color: color.surface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
