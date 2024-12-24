import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Check if a movie is marked as favorite or dislike
  RxBool isFavorite = false.obs;
  RxBool isDisliked = false.obs;

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String movieId, String movieName) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    if (isFavorite.value) {
      // Remove favorite
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .delete();
      isFavorite.value = false;
    } else {
      // Add to favorites and remove dislike if exists
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .set({
        'movieId': movieId,
        'movieName': movieName, // Storing the movie name
      });
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .delete();
      isFavorite.value = true;
      isDisliked.value = false;
    }
  }

  /// Toggle dislike status
  Future<void> toggleDislike(String movieId, String movieName) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    if (isDisliked.value) {
      // Remove dislike
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .delete();
      isDisliked.value = false;
    } else {
      // Add to dislikes and remove favorite if exists
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Dislikes')
          .doc(movieId)
          .set({
        'movieId': movieId,
        'movieName': movieName, // Storing the movie name
      });
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Favorites')
          .doc(movieId)
          .delete();
      isDisliked.value = true;
      isFavorite.value = false;
    }
  }

  /// Load initial favorite/dislike status
  Future<void> loadMovieStatus(String movieId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    final favoriteDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('Favorites')
        .doc(movieId)
        .get();
    final dislikeDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('Dislikes')
        .doc(movieId)
        .get();

    isFavorite.value = favoriteDoc.exists;
    isDisliked.value = dislikeDoc.exists;
  }
}
