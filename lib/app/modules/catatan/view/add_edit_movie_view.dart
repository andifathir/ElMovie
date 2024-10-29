import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddEditMovieListView extends StatefulWidget {
  final String? id;
  final String? judul;
  final String? deskripsi;
  final DateTime? tanggal;

  const AddEditMovieListView({Key? key, this.id, this.judul, this.deskripsi, this.tanggal}) : super(key: key);

  @override
  _AddEditMovieListViewState createState() => _AddEditMovieListViewState();
}

class _AddEditMovieListViewState extends State<AddEditMovieListView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String judul;
  late String deskripsi;
  late DateTime tanggal;

  @override
  void initState() {
    super.initState();
    judul = widget.judul ?? '';
    deskripsi = widget.deskripsi ?? '';
    tanggal = widget.tanggal ?? DateTime.now();
  }

  Future<void> saveCatatan() async {
    if (widget.id == null) {
      await firestore.collection('catatan').add({
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal': Timestamp.fromDate(tanggal),
      });
    } else {
      await firestore.collection('catatan').doc(widget.id).update({
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal': Timestamp.fromDate(tanggal),
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
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: tanggal,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != tanggal) {
                  setState(() {
                    tanggal = picked;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tanggal: ${tanggal.toLocal()}'.split(' ')[0],
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
