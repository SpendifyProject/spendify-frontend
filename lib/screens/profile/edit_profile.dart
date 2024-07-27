import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spendify/provider/user_provider.dart';
import 'package:spendify/services/validation_service.dart';
import 'package:spendify/widgets/error_dialog.dart';

import '../../const/constants.dart';
import '../../models/user.dart';
import '../../widgets/custom_auth_text_field.dart';
import '../animations/done.dart';
import '../dashboard/dashboard.dart';

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
  String email = firebaseEmail;
  String? nameError;
  String? numberError;
  String? emailError;
  String? incomeError;
  String? dateError;

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
            dateController.text = formatDate(_selectedDate!);
            return ListView(
              padding: EdgeInsets.symmetric(
                vertical: 25.h,
                horizontal: 10.w,
              ),
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
                  child: SizedBox(
                    height: 400.h,
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
                          errorText: emailError,
                          validator: (value) {
                            emailError = Validator.validateEmail(value);
                            return emailError;
                          },
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
                          errorText: incomeError,
                          validator: (value) {
                            incomeError = Validator.validateAmount(value);
                            return incomeError;
                          },
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
                                initialDate: _selectedDate ?? DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: color.primary,
                                      colorScheme:
                                          const ColorScheme.light().copyWith(
                                        primary: color.primary,
                                        onPrimary: color.onPrimary,
                                        surface: color.surface,
                                      ),
                                      dialogBackgroundColor: color.surface,
                                      textTheme: GoogleFonts.poppinsTextTheme(),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((pickedDate) async{
                                if (pickedDate != null) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                    dateController.text = formatDate(_selectedDate!);
                                  });
                                  await userProvider.updateDate(user.uid, _selectedDate!);
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
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            nameError = null;
                            numberError = null;
                            emailError = null;
                            incomeError = null;
                            dateError = null;
                          });
                          User newUser = User(
                            uid: user.uid,
                            imagePath: user.imagePath,
                            fullName: nameController.text,
                            phoneNumber: numberController.text,
                            email: emailController.text,
                            monthlyIncome: double.parse(incomeController.text),
                            dateOfBirth: _selectedDate!,
                          );
                          await userProvider.updateUser(user.uid, newUser);
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
                        }
                      } catch (error) {
                        showErrorDialog(context, 'Error: $error');
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
