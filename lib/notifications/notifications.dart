import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    /*await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future showScheduleNotification(
      int notificationId,
      String title,
      String body,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      NotificationDetails platformChannelSpecifics,
      DateTime scheduledNotificationDateTime) async {
    await flutterLocalNotificationsPlugin.schedule(notificationId, title, body,
        scheduledNotificationDateTime, platformChannelSpecifics,
        payload: 'whatever');
  }
}
