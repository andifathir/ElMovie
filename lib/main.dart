import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/modules/profile/providers/profile_provider.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'app/modules/notifications/notification_handler.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationHandler().showNotification(
    message.notification?.title,
    message.notification?.body,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler only on platforms that support it
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  NotificationHandler().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: GetMaterialApp(
        title: "ELMOVIE",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Reminder'),
        content: Text(
            "Hey! Don’t forget, your movie is waiting 🎬 Enjoy your time!"),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  });
}
