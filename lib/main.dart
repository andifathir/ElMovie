import 'package:ElMovie/dependency_injection.dart';
import 'package:ElMovie/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/modules/location/controllers/location_controller.dart';
import 'app/modules/notification/notification_service.dart';
import 'app/modules/profile/providers/profile_provider.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: GetMaterialApp(
        title: "ELMOVIE",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: BindingsBuilder(() {
          Get.put(
              LocationController()); // Controller untuk fitur lokasi bioskop
        }),
      ),
    ),
  );
  DependencyInjection.init();
}
