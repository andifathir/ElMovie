import 'package:get/get.dart';

import '../controller/catatan_controller.dart';

class CatatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatatanController>(() => CatatanController());
  }
}