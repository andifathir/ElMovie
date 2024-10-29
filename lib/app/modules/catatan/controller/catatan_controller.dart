
import 'package:cloud_firestore/cloud_firestore.dart';

class CatatanController {
  final CollectionReference _catatanCollection =
      FirebaseFirestore.instance.collection('catatan');

  // Fungsi untuk Menambahkan Catatan
  Future<void> tambahCatatan(String judul, String deskripsi, DateTime tanggal) async {
    await _catatanCollection.add({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': Timestamp.fromDate(tanggal),
    });
  }

  // Fungsi untuk Mendapatkan Daftar Catatan
  Stream<List<Map<String, dynamic>>> getCatatanList() {
    return _catatanCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;  // Menyimpan doc.id untuk referensi pada operasi selanjutnya
          return data;
        }).toList());
  }

  // Fungsi untuk Memperbarui Catatan
  Future<void> updateCatatan(String id, String judul, String deskripsi, DateTime tanggal) async {
    await _catatanCollection.doc(id).update({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': Timestamp.fromDate(tanggal),
    });
  }

  // Fungsi untuk Menghapus Catatan
  Future<void> hapusCatatan(String id) async {
    await _catatanCollection.doc(id).delete();
  }
}
