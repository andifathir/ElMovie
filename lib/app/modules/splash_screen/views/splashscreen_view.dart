import 'package:ElMovie/app/modules/login/controllers/auth_controller.dart';
import 'package:ElMovie/app/modules/login/views/login_view.dart';
import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:get/get.dart';
import '../controllers/splashscreen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: Colors.black,
      onInit: () {
        debugPrint("On Init");
        Get.put(AuthController()); // Initialize AuthController
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset("assets/Logo Awal Splash Screen.png"),
      ),
      onAnimationEnd: () {
        debugPrint("On Fade In End");
        // Navigate to LoginView after the animation ends
        Get.offNamed(Routes.LOGIN);
      },
    );
  }
}
