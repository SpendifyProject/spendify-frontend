import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/widgets/custom_auth_text_field.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late TextEditingController titleController;
  late TextEditingController contentController;

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
          20.h,
          10.w,
          20.h,
          0,
        ),
        child: ListView(
          children: [
            CustomAuthTextField(
              controller: titleController,
              obscureText: false,
              icon: Icon(
                Icons.topic_outlined,
                color: color.secondary,
                size: 30,
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
                fontSize: 14,
                color: color.secondary,
              ),
            ),
            TextField(
              controller: contentController,
              maxLines: 10,
              maxLength: 800,
              style: TextStyle(color: color.onPrimary, fontSize: 14),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Send Message',
                  style: TextStyle(
                    color: color.background,
                    fontSize: 14,
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
