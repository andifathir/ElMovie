import 'package:ElMovie/app/modules/profile/bindings/profile_binding.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
import 'package:ElMovie/app/modules/splash_screen/bindings/splashscreen_binding.dart';
import 'package:ElMovie/app/modules/splash_screen/views/splashscreen_view.dart';
import 'package:ElMovie/app/modules/login/bindings/login_binding.dart';
import 'package:ElMovie/app/modules/login/views/login_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SplashScreen,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.Login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.Profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
