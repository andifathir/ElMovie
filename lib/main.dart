import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/modules/profile/providers/profile_provider.dart'; // Perbaiki path jika perlu
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileProvider()), // Provider untuk Profile
      ],
      child: GetMaterialApp(
        title: "Elmovie",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        initialBinding: BindingsBuilder(() {
          Get.put(LoginController());
        }),
      ),
    ),
  );
}
