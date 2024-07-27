import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendify/models/user.dart';
import 'package:spendify/services/notification_service.dart';
import 'package:spendify/widgets/error_dialog.dart';
import 'package:spendify/models/notification.dart' as n;

class Notifications extends StatelessWidget {
  const Notifications({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
        future: NotificationService.fetchNotifications(user),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            showErrorDialog(context, 'Error: ${snapshot.error}');
          }
          else if(snapshot.hasData){
            List<n.Notification> notifications = snapshot.data ?? [];
            return notifications.isEmpty
            ? const SizedBox()
            : ListView.builder(
              itemCount: notifications.length,
              padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 10.w,
            ),
              itemBuilder: (context, index){
                n.Notification notification = notifications[index];
                return ListTile(
                  leading: Icon(
                    Icons.notifications_none,
                    color: color.secondary,
                    size: 20.sp,
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  subtitle: Text(
                    notification.body,
                    style: TextStyle(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
