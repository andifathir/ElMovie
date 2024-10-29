
import 'package:flutter_application_1/app/modules/catatan/bindings/catatan_bindings.dart';
import 'package:flutter_application_1/app/modules/movie_detail/bindings/movie_detail_binding.dart';
import 'package:flutter_application_1/app/modules/movie_detail/view/movie_detail_view.dart';
import 'package:flutter_application_1/app/modules/profile/bindings/profile_binding.dart';
import 'package:flutter_application_1/app/modules/profile/views/profile_view.dart';
import 'package:flutter_application_1/app/modules/splash_screen/bindings/splashscreen_binding.dart';
import 'package:flutter_application_1/app/modules/splash_screen/views/splashscreen_view.dart';
import 'package:flutter_application_1/app/modules/login/bindings/login_binding.dart';
import 'package:flutter_application_1/app/modules/login/views/login_view.dart';
import 'package:get/get.dart';

import '../modules/catatan/view/catatan_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/controllers/login_controller.dart';
import '../modules/movie_detail/view/movie_detail_web_view.dart';


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
      binding: LoginBinding((){
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: _Paths.Profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MOVIE_DETAILS,
      page: () => MovieDetailView(movie: Get.arguments),
      binding: MovieDetailBinding(),
    ),
    GetPage(
      name: _Paths.MOVIE_DETAILS_WEBVIEW,
      page: () => MovieDetailWebView(movie: Get.arguments),
      binding: MovieDetailBinding(),
    ),
    GetPage(
      name: _Paths.CATATAN, 
      page: () => CatatanView(),
      binding: CatatanBinding(),
      )
  ];
}
