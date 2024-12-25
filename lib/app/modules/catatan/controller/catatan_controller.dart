import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatatanController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final RxList<Map<String, dynamic>> catatanList = <Map<String, dynamic>>[].obs;
  final box = GetStorage();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind Catatan dari Firestore
    catatanList.bindStream(getCatatanList());
    // Initialize connectivity
    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first; // Get first connection result
      _handleConnectivityChange(result);
    });
    // Sync local data
    _syncLocalData();
  }

  /// Get UID of the currently logged-in user
  String? get uid => auth.currentUser?.uid;

  /// Stream Firestore to get notes for the logged-in user
  Stream<List<Map<String, dynamic>>> getCatatanList() {
    if (uid == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('users')
        .doc(uid)
        .collection('Catatan')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Add note to Firestore or save locally if offline
  Future<void> tambahCatatan(
      String judul, String deskripsi, String tanggal) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    final data = {
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    };

    if (isConnected.value) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('Catatan')
          .add(data);
      // Get.snackbar('Berhasil', 'Catatan berhasil dikirim ke database!',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Get.theme.primaryColor,
      //     colorText: Get.theme.colorScheme.onPrimary);
    } else {
      final List localData = box.read('localCatatan') ?? [];
      localData.add(data);
      box.write('localCatatan', localData);
      Get.snackbar('Offline', 'Catatan disimpan secara lokal.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.hintColor,
          colorText: Get.theme.colorScheme.onPrimary);
    }
  }

  /// Delete note from Firestore
  Future<void> hapusCatatan(String id) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('Catatan')
        .doc(id)
        .delete();
  }

  /// Update note in Firestore
  Future<void> updateCatatan(
      String id, String judul, String deskripsi, String tanggal) async {
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('Catatan')
        .doc(id)
        .update({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    });
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    if (isConnected.value) {
      _syncLocalData();
    }
  }

  /// Sync local data to Firestore if connected
  Future<void> _syncLocalData() async {
    if (uid == null) return;

    final List localData = box.read('localCatatan') ?? [];
    if (localData.isNotEmpty && isConnected.value) {
      for (var data in localData) {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('Catatan')
            .add(data);
      }
      box.remove('localCatatan'); // Remove local data after syncing
      Get.snackbar(
          'Sinkronisasi', 'Data lokal berhasil disinkronisasi ke database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    }
  }
}
