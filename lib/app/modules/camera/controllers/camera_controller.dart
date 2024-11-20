import 'package:camera/camera.dart';
import 'package:get/get.dart';

class AppCameraController extends GetxController {
  late CameraController? cameraController;
  RxString filePath = ''.obs;
  RxString fileType = ''.obs;

  // Initialize the camera
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,  // Select the first available camera
      ResolutionPreset.high,
    );

    await cameraController!.initialize();
  }
}
