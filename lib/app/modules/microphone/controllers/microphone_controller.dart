import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:ElMovie/app/modules/home/controllers/home_controller.dart';

class MicrophoneController extends GetxController {
  final SpeechToText speechToText = SpeechToText();
  var isListening = false.obs; // Listening status
  var text = ''.obs; // Recognized text
  var localeId = 'id_ID'; // Default language (Indonesian)

  final HomeController homeController = Get.find(); // Access HomeController

  void startListening() async {
    print('Initializing SpeechToText...');
    bool available = await speechToText.initialize(
      onStatus: (status) => print('SpeechToText status: $status'),
      onError: (error) => print('SpeechToText error: $error'),
    );

    if (available) {
      print('Speech recognition is available. Starting to listen...');
      isListening.value = true;

      speechToText.listen(
        onResult: (result) {
          text.value = result.recognizedWords; // Update recognized text
          homeController.searchQuery.value =
              text.value; // Update HomeController search
        },
        listenFor: const Duration(minutes: 1),
        localeId: localeId,
        cancelOnError: false,
        partialResults: true,
      );
    } else {
      print('Speech recognition is not available.');
      Get.snackbar('Error', 'Speech recognition not available',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void stopListening() {
    print('Stopping listening...');
    speechToText.stop();
    isListening.value = false;
  }

  void switchLanguage(String languageCode) {
    localeId = languageCode;
    print('Language switched to: $languageCode');
    Get.snackbar('Language Switched', 'Now listening in $languageCode',
        snackPosition: SnackPosition.BOTTOM);
  }
}
