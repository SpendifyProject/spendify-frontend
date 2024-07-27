import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/routes.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.imagePath, required this.name});

  final String imagePath;
  final String name;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, profileRoute);
        },
        child: ClipOval(
          child: Image.network(
            imagePath,
            width: 50.w,
            height: 50.h,
          ),
        ),
      ),
      title: Text(
        'Welcome,',
        style: TextStyle(
          color: color.secondary,
          fontSize: 12.sp,
        ),
      ),
      subtitle: Text(
        name,
        style: TextStyle(
          color: color.onPrimary,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
