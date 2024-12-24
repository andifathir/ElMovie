import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final favorites = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Access uid from ProfileController
  String? get uid => auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    isLoading.value = true;
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .get();

      favorites.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch favorite movies: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
