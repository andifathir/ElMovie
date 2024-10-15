import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:get/get.dart';

class MovieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MovieController>(
      () => MovieController(),
    );
  }
}
