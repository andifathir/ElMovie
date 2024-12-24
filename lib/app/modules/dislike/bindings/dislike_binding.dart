import 'package:get/get.dart';

import '../controllers/dislike_controller.dart';

class DislikeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DislikeController>(
      () => DislikeController(),
    );
  }
}
