import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CatatanController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> catatanList = <Map<String, dynamic>>[].obs;
  final box = GetStorage();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind Catatan dari Firestore
    catatanList.bindStream(getCatatanList());
    // Inisialisasi konektivitas
    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first; // Ambil hasil koneksi pertama
      _handleConnectivityChange(result);
    });
    // Sinkronisasi data lokal
    _syncLocalData();
  }

  /// Stream Firestore untuk mendapatkan catatan
  Stream<List<Map<String, dynamic>>> getCatatanList() {
    return firestore.collection('Catatan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Tambah catatan ke Firestore atau simpan ke lokal jika offline
  Future<void> tambahCatatan(
      String judul, String deskripsi, String tanggal) async {
    final data = {
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    };

    if (isConnected.value) {
      await firestore.collection('Catatan').add(data);
      Get.snackbar('Berhasil', 'Catatan berhasil dikirim ke database!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary);
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

  /// Hapus catatan dari Firestore
  Future<void> hapusCatatan(String id) async {
    await firestore.collection('Catatan').doc(id).delete();
  }

  /// Update catatan di Firestore
  Future<void> updateCatatan(
      String id, String judul, String deskripsi, String tanggal) async {
    await firestore.collection('Catatan').doc(id).update({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    });
  }

  /// Handle perubahan konektivitas
  void _handleConnectivityChange(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    if (isConnected.value) {
      _syncLocalData(); // Fungsi async dipanggil tanpa await
      Get.snackbar(
        'Online',
        'Data lokal berhasil disinkronisasi ke database.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Offline',
        'Koneksi internet terputus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Sinkronisasi data lokal ke Firestore jika ada koneksi
  Future<void> _syncLocalData() async {
    final List localData = box.read('localCatatan') ?? [];
    if (localData.isNotEmpty && isConnected.value) {
      for (var data in localData) {
        await firestore.collection('Catatan').add(data);
      }
      box.remove('localCatatan'); // Hapus data lokal setelah sinkronisasi
      Get.snackbar(
          'Sinkronisasi', 'Data lokal berhasil disinkronisasi ke database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    }
  }
}
