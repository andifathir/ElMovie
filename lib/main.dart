import 'package:ElMovie/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/modules/notification/notifikasi_local.dart';
import 'app/modules/notification/notifikasi_service.dart';
import 'app/modules/profile/providers/profile_provider.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi notifikasi lokal dan FCM
  await NotifikasiLocal.init();
  NotifikasiService().init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Menampilkan notifikasi segera saat aplikasi di-run
  NotifikasiLocal.showImmediateNotification();

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
}
