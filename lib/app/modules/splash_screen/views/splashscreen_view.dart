import 'package:ElMovie/app/modules/home/views/home_view.dart';
import 'package:ElMovie/app/modules/navbar/views/navbar_view.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:ElMovie/app/modules/login/views/login_view.dart';
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
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset("assets/logo.png"),
      ),
      onAnimationEnd: () => debugPrint("On Fade In End"),
      nextScreen: const LoginView(),
    );
  }
}
