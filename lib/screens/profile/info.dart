import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/const/constants.dart';

import '../../models/user.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
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
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 10.w,
        ),
        children: [
          SizedBox(
            height: 30.h,
          ),
          Center(
            child: ClipOval(
              child: Image.network(
                user.imagePath,
                width: 150.w,
                height: 150.h,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          ListTile(
            title: Text(
              'Full Name',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              user.fullName,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Email',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              user.email,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'User ID',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              user.uid,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              user.phoneNumber,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Expected Monthly Income',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              'GHc ${formatAmount(user.monthlyIncome)}',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Date of Birth',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: color.secondary,
              ),
            ),
            subtitle: Text(
              formatDate(user.dateOfBirth),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
