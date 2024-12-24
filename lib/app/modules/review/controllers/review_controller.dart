import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ReviewController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final RxList<Map<String, dynamic>> reviewList = <Map<String, dynamic>>[].obs;
  final box = GetStorage();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    reviewList.bindStream(getReviewList());
    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first;
      _handleConnectivityChange(result);
    });
    _syncLocalData();
  }

  String? get uid => auth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getReviewList() {
    if (uid == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('users')
        .doc(uid)
        .collection('Reviews')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addReview(
      String movieName, double rating, String review, File? image) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    final data = {
      'movieName': movieName,
      'rating': rating,
      'review': review,
      'imagePath': image?.path ?? '',
    };

    if (isConnected.value) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Reviews')
          .add(data);
      Get.snackbar('Success', 'Review added successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary);
    } else {
      final List localData = box.read('localReviews') ?? [];
      localData.add(data);
      box.write('localReviews', localData);
      Get.snackbar('Offline', 'Review saved locally.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.hintColor,
          colorText: Get.theme.colorScheme.onPrimary);
    }
  }

  Future<void> updateReview(String id, String movieName, double rating,
      String review, File? image) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('Reviews')
        .doc(id)
        .update({
      'movieName': movieName,
      'rating': rating,
      'review': review,
      'imagePath': image?.path ?? '',
    });
  }

  Future<void> deleteReview(String id) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('Reviews')
        .doc(id)
        .delete();
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    if (isConnected.value) {
      _syncLocalData();
      Get.snackbar('Online', 'Local data synced to database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      Get.snackbar('Offline', 'Internet connection lost.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _syncLocalData() async {
    if (uid == null) return;

    final List localData = box.read('localReviews') ?? [];
    if (localData.isNotEmpty && isConnected.value) {
      for (var data in localData) {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('Reviews')
            .add(data);
      }
      box.remove('localReviews');
      Get.snackbar('Sync', 'Local data synced to database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    }
  }

  // Method to pick an image from the gallery
  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // Method to take a photo or video using the camera
  Future<File?> takePhotoOrVideo() async {
    final pickedFile = await Get.dialog(
      AlertDialog(
        title: Text("Choose Action"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              label: Text("Take Photo"),
              onPressed: () async {
                final XFile? photo =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                Get.back(result: photo);
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.videocam),
              label: Text("Record Video"),
              onPressed: () async {
                final XFile? video =
                    await ImagePicker().pickVideo(source: ImageSource.camera);
                Get.back(result: video);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile is XFile) {
      return File(pickedFile.path);
    }
    return null;
  }
}
