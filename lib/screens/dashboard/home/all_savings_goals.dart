import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/user.dart';

class AllSavingsGoals extends StatefulWidget {
  const AllSavingsGoals({super.key, required this.user});

  final User user;

  @override
  State<AllSavingsGoals> createState() => _AllSavingsGoalsState();
}

class _AllSavingsGoalsState extends State<AllSavingsGoals> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          'Savings',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        children: [
          Container(
            width: double.infinity,
            height: 176.h,
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 20.w,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(55, 124, 200, 1),
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Play Station 5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '50%',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                LinearProgressIndicator(
                  minHeight: 4.h,
                  borderRadius: BorderRadius.circular(2.r),
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  value: 0.5,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'GHc 4,000.00',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )
                          ),
                          TextSpan(
                              text: '  of GHc 8,000.00',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )
                          ),
                        ]
                      ),
                    ),
                    Text(
                      '3 years left',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
