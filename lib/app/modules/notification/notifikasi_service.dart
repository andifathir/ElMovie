import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notifikasi_local.dart';

class NotifikasiService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Permission untuk iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handler untuk keadaan aplikasi berjalan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotifikasiLocal.showNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
    });

    // Handler untuk aplikasi di background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotifikasiLocal.showNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
    });

    // Set token untuk perangkat
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token"); // Gunakan untuk debugging atau testing
    });
  }
}

// Handler background yang diperlukan oleh FCM
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotifikasiLocal.showNotification(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
  );
}
