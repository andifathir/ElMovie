import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditMovieListView extends StatefulWidget {
  final String? id;
  final String? judul;
  final String? deskripsi;
  final String? tanggal; // Ubah tipe data tanggal menjadi String

  const AddEditMovieListView({Key? key, this.id, this.judul, this.deskripsi, this.tanggal}) : super(key: key);

  @override
  _AddEditMovieListViewState createState() => _AddEditMovieListViewState();
}

class _AddEditMovieListViewState extends State<AddEditMovieListView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String judul;
  late String deskripsi;
  late String tanggal; // Ubah tipe data tanggal menjadi String

  @override
  void initState() {
    super.initState();
    judul = widget.judul ?? '';
    deskripsi = widget.deskripsi ?? '';
    tanggal = widget.tanggal ?? DateTime.now().toIso8601String(); // Mengonversi ke string ISO
  }

  Future<void> saveCatatan() async {
    if (widget.id == null) {
      await firestore.collection('catatan').add({
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal': tanggal, // Simpan tanggal sebagai string
      });
    } else {
      await firestore.collection('catatan').doc(widget.id).update({
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal': tanggal, // Simpan tanggal sebagai string
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Tambah Movie List' : 'Edit Movie List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                judul = value;
              },
              decoration: const InputDecoration(hintText: 'Judul'),
              controller: TextEditingController(text: judul),
            ),
            TextField(
              onChanged: (value) {
                deskripsi = value;
              },
              decoration: const InputDecoration(hintText: 'Deskripsi'),
              controller: TextEditingController(text: deskripsi),
            ),
            GestureDetector(
              onTap: () async {
                DateTime currentDate = DateTime.parse(tanggal);
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != currentDate) {
                  setState(() {
                    tanggal = picked.toIso8601String(); // Simpan dalam format string ISO
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tanggal: ${DateTime.parse(tanggal).toLocal()}'.split(' ')[0], // Tampilkan dalam format tanggal
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveCatatan,
              child: Text(widget.id == null ? 'Add Movie List' : 'Update Movie List'),
            ),
          ],
        ),
      ),
    );
  }
}
