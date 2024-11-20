import 'package:get/get.dart';
import '../controllers/microphone_controller.dart';

class MicrophoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MicrophoneController>(() => MicrophoneController());
  }
}
