import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifikasiLocal {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Channel for general notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Fungsi untuk menampilkan notifikasi segera saat aplikasi dijalankan
  static Future<void> showImmediateNotification() async {
    await showNotification(
      title: "Hey! Don’t forget, your movie is waiting 🎬 Enjoy your time!",
      body: "Jangan lupa, film Anda menanti untuk ditonton!",
    );
  }
}
