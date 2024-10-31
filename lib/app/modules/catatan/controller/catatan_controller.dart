import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CatatanController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> catatanList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    catatanList.bindStream(getCatatanList());
    super.onInit();
  }

  Stream<List<Map<String, dynamic>>> getCatatanList() {
    return firestore.collection('Catatan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> tambahCatatan(
      String judul, String deskripsi, String tanggal) async {
    await firestore.collection('Catatan').add({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    });
  }

  Future<void> hapusCatatan(String id) async {
    await firestore.collection('Catatan').doc(id).delete();
  }

  Future<void> updateCatatan(
      String id, String judul, String deskripsi, String tanggal) async {
    await firestore.collection('Catatan').doc(id).update({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    });
  }
}
