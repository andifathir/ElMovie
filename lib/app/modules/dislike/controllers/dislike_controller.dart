import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DislikeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dislikes = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Access uid from ProfileController
  String? get uid => auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchDislikes();
  }

  Future<void> fetchDislikes() async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    isLoading.value = true;
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .get();

      dislikes.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch disliked movies: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
