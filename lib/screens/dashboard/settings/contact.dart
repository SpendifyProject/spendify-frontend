import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/const/constants.dart';
import 'package:spendify/const/snackbar.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';
import 'package:spendify/widgets/error_dialog.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  String? titleError;
  String? contentError;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact',
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20.h,
          10.w,
          20.h,
          0,
        ),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAuthTextField(
                    controller: titleController,
                    obscureText: false,
                    errorText: titleError,
                    validator: (value) {
                      if (value == null) {
                        titleError = 'Please enter the title of your message';
                        return titleError;
                      }
                      return null;
                    },
                    icon: Icon(
                      Icons.topic_outlined,
                      color: color.secondary,
                      size: 30.sp,
                    ),
                    keyboardType: TextInputType.text,
                    labelText: 'Title',
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: color.secondary,
                    ),
                  ),
                  TextFormField(
                    controller: contentController,
                    maxLines: 10,
                    maxLength: 800,
                    validator: (value) {
                      if (value == null) {
                        contentError =
                            'Please enter the content of your message';
                        return contentError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: color.onPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      errorText: contentError,
                      errorMaxLines: 2,
                      errorStyle: TextStyle(
                        color: color.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        titleError = null;
                        contentError = null;
                      });
                      await sendEmail(
                        toEmail: 'emmanueldokeii@gmail.com',
                        subject: titleController.text,
                        body: contentController.text,
                      );
                      showCustomSnackbar(context, 'Email sent successfully');
                    }
                  } catch (error) {
                    showErrorDialog(context, 'Error: $error');
                  }
                },
                child: Text(
                  'Send Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
