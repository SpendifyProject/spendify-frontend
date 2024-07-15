import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MomoWidget extends StatelessWidget {
  const MomoWidget(
      {super.key,
      required this.phoneNumber,
      required this.fullName,
      required this.network});

  final String phoneNumber;
  final String fullName;
  final String network;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: 335.w,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromRGBO(30, 30, 45, 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          20.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phoneNumber,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
            Text(
              fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            const Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Network',
                style: TextStyle(
                  color: color.secondary,
                  fontSize: 9.sp,
                ),
              ),
              subtitle: Text(
                network.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Image.asset(
                'assets/images/${network.toLowerCase()}.jpg',
                height: 30.h,
                width: 50.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
