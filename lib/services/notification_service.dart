import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spendify/models/user.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:spendify/models/notification.dart' as n;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(
      n.Notification notification) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        'channel_Name',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
    saveNotification(notification);
  }

  static Future<void> scheduleNotification(n.Notification notification) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        'channel_Name',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      notification.title,
      notification.body,
      tz.TZDateTime.from(notification.date, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
    saveNotification(notification);
  }

  static Future<void> saveNotification(n.Notification notification) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.id)
          .set({
        'id': notification.id,
        'uid': notification.uid,
        'title': notification.title,
        'body': notification.body,
        'date': notification.date,
      });
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  static Future<List<n.Notification>> fetchNotifications(User user) async {
    try {
      List<n.Notification> notifications = [];
      final notiSnap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('uid', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .get();

      for (final doc in notiSnap.docs) {
        n.Notification notification = n.Notification(
          uid: doc['uid'] as String,
          id: doc['id'] as String,
          title: doc['title'] as String,
          body: doc['body'] as String,
          date: (doc['date'] as Timestamp).toDate(),
        );
        notifications.add(notification);
      }
      return notifications;
    } catch (error) {
      log('Error: $error');
      return [];
    }
  }
}
