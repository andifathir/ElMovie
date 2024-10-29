// Movie Detail
import 'package:ElMovie/app/modules/movie_detail/bindings/movie_detail_binding.dart';
import 'package:ElMovie/app/modules/movie_detail/views/movie_detail_view.dart';
import 'package:ElMovie/app/modules/movie_detail/views/movie_detail_web_view.dart';
// Navbar
import 'package:ElMovie/app/modules/navbar/bindings/navbar_binding.dart';
// Profile
import 'package:ElMovie/app/modules/profile/bindings/profile_binding.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
//SplashScreen
import 'package:ElMovie/app/modules/splash_screen/views/splashscreen_view.dart';
// Login
import 'package:ElMovie/app/modules/login/bindings/auth_binding.dart';
import 'package:ElMovie/app/modules/login/views/login_view.dart';
import 'package:ElMovie/app/modules/login/views/register_view.dart';
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
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: _Paths.SplashScreen,
        page: () => const SplashScreenView(),
        bindings: [
          HomeBinding(),
          NavbarBinding(),
        ]),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
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
  ];
}
