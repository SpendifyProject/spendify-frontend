import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendify/const/sizing_config.dart';
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
                vertical: verticalConverter(context, 25),
                horizontal: horizontalConverter(context, 10),
              ),
              child: ListView(
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        user.imagePath,
                        width: horizontalConverter(context, 90),
                        height: verticalConverter(context, 90),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: verticalConverter(context, 20),
                  ),
                  Form(
                    key: formKey,
                    child: CustomAuthTextField(
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
                                content:
                                    Text('Please select your date of birth'),
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
                      onPressed: null,
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          color: color.background,
                          fontSize: 16,
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
