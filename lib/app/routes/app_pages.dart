import 'package:get/get.dart';

import '../modules/catatan/bindings/catatan_bindings.dart';
import '../modules/catatan/view/catatan_view.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/location_view.dart';
import '../modules/login/bindings/auth_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/register_view.dart';
import '../modules/movie_detail/bindings/movie_detail_binding.dart';
import '../modules/movie_detail/views/movie_detail_view.dart';
import '../modules/movie_detail/views/movie_detail_web_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/splash_screen/bindings/splashscreen_binding.dart';
import '../modules/splash_screen/views/splashscreen_view.dart';

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
    GetPage(name: _Paths.NAVBAR, page: () => const NavbarView(), bindings: [
      NavbarBinding(),
      HomeBinding(),
      CatatanBinding(),
      ReviewBinding(),
      ProfileBinding()
    ]),
    GetPage(
        name: _Paths.SplashScreen,
        page: () => const SplashScreenView(),
        bindings: [
          SplashScreenBinding(),
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
    GetPage(
      name: _Paths.CATATAN,
      page: () => const CatatanView(),
      binding: CatatanBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => ConnectionView(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
  ];
}
