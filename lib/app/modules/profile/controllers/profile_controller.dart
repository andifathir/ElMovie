import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first;
      _handleConnectivityChange(result);
    });
  }

  String? get uid => auth.currentUser?.uid;

  Future<void> _loadProfileData() async {
    if (uid == null) return;

    try {
      final DocumentSnapshot profileDoc = await firestore
          .collection('users')
          .doc(uid)
          .collection('Profile')
          .doc('main')
          .get();

      if (profileDoc.exists) {
        profileData.assignAll(profileDoc.data() as Map<String, dynamic>);
      } else {
        profileData.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data: $e');
    }
  }

  Future<void> saveProfileData() async {
    if (uid == null) return;

    final data = {
      'username': profileData['username'] ?? '',
      'favoriteGenre': profileData['favoriteGenre'] ?? '',
      'imagePath': profileImage.value?.path ?? '', // Include local image path
    };

    try {
      if (isConnected.value) {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('Profile')
            .doc('main')
            .set(data);
        Get.snackbar(
            'Profile Updated', 'Your profile has been updated successfully.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        profileData['imagePath'] =
            profileImage.value?.path ?? ''; // Save locally
        await firestore
            .collection('users')
            .doc(uid)
            .collection('Profile')
            .doc('main')
            .set(data);
        Get.snackbar('Offline', 'Profile data stored locally.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.hintColor,
            colorText: Get.theme.colorScheme.onPrimary);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile data: $e');
    }
  }

  Future<void> updateProfile(String username, String favoriteGenre) async {
    profileData['username'] = username;
    profileData['favoriteGenre'] = favoriteGenre;
    await saveProfileData();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);

      // Save the image path directly to Firestore
      profileData['imagePath'] = profileImage.value!.path;
      await saveProfileData();
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    if (isConnected.value) {
      // Get.snackbar('Online', 'Back online. Data synced successfully.',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white);
    }
    // else {
    //   Get.snackbar('Offline', 'Internet connection lost.',
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.red,
    //       colorText: Colors.white);
    // }
  }

  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed('/login'); // Navigate to login page
  }
}
