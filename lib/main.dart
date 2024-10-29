import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'app/modules/notifications/notification_handler.dart';
import 'app/modules/profile/providers/profile_provider.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notifications
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

  // Display dialog on app startup
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
