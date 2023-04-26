import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sun_point/utils/auth.dart';
// import 'package:wise_premium/logic/providers/account.dart';

class NotificationHelper {
  static void listenOnToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      try {
        await User.getUser();
        // TODO: enable the api
        // await AccountAPI.updateFCMToken(token);
      } catch (e) {
        return;
      }
    });
  }

  static void setup() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static void add(String title, String text) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'WS1',
      'wise premium',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000),
      title,
      text,
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  return;
  NotificationHelper.setup();
  if (message.notification != null) {
    NotificationHelper.add(
        message.notification!.title!, message.notification!.body!);
  }
}
