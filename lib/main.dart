import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/modules/profile/providers/profile_provider.dart'; // Perbaiki path jika perlu
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: GetMaterialApp(
        title: "Application",
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
