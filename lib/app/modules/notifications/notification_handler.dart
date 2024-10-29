import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationHandler() {
    initialize();
  }

  void initialize() async {
    // Local Notification Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap response here if needed
      },
    );

    // Request notification permissions for iOS
    await _firebaseMessaging.requestPermission();

    // Foreground notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        message.notification?.title,
        message.notification?.body,
      );
    });

    // Notification on app launch from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotification(
        message.notification?.title,
        message.notification?.body,
      );
    });
  }

  Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
