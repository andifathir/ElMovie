import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CatatanView extends StatefulWidget {
  const CatatanView({Key? key}) : super(key: key);

  @override
  _CatatanViewState createState() => _CatatanViewState();
}

class _CatatanViewState extends State<CatatanView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      'tanggal': tanggal, // Simpan tanggal sebagai string
    });
  }

  Future<void> hapusCatatan(String id) async {
    await firestore.collection('Catatan').doc(id).delete();
  }

  Future<void> showAddCatatanDialog(BuildContext context) async {
    String judul = '';
    String deskripsi = '';
    String tanggal = DateFormat('d MMMM yyyy').format(DateTime.now());

    await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tambah Catatan'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      judul = value;
                    },
                    decoration: const InputDecoration(hintText: 'Judul'),
                  ),
                  TextField(
                    onChanged: (value) {
                      deskripsi = value;
                    },
                    decoration: const InputDecoration(hintText: 'Deskripsi'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          tanggal = DateFormat('d MMMM yyyy').format(picked);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tanggal: $tanggal',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  if (judul.isNotEmpty && deskripsi.isNotEmpty) {
                    tambahCatatan(judul, deskripsi, tanggal);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Simpan'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
            ],
          );
        });
  }

  Future<void> showEditCatatanDialog(BuildContext context, String id,
      String judul, String deskripsi, String tanggal) async {
    final TextEditingController judulController =
        TextEditingController(text: judul);
    final TextEditingController deskripsiController =
        TextEditingController(text: deskripsi);
    String selectedDate = tanggal;

    await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Catatan'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: judulController,
                    decoration: const InputDecoration(hintText: 'Judul'),
                  ),
                  TextField(
                    controller: deskripsiController,
                    decoration: const InputDecoration(hintText: 'Deskripsi'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            DateFormat('d MMMM yyyy').parse(selectedDate),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate =
                              DateFormat('d MMMM yyyy').format(picked);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tanggal: $selectedDate',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  final updatedJudul = judulController.text;
                  final updatedDeskripsi = deskripsiController.text;
                  if (updatedJudul.isNotEmpty && updatedDeskripsi.isNotEmpty) {
                    updateCatatan(
                        id, updatedJudul, updatedDeskripsi, selectedDate);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
            ],
          );
        });
  }

  Future<void> updateCatatan(
      String id, String judul, String deskripsi, String tanggal) async {
    await firestore.collection('Catatan').doc(id).update({
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal, // Update tanggal sebagai string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/BG_BELAKANG_HOME.png', // Ganti dengan path gambar yang kamu miliki
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Catatan', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: getCatatanList(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final catatanList = snapshot.data ?? [];
              return ListView.builder(
                itemCount: catatanList.length,
                itemBuilder: (context, index) {
                  final catatan = catatanList[index];
                  return ListTile(
                    title: Text(catatan['judul'] ?? 'No Title',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(catatan['deskripsi'] ?? 'No Description',
                            style: TextStyle(color: Colors.white)),
                        Text(
                          'Tanggal: ${catatan['tanggal'] ?? 'Tanggal tidak tersedia'}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showEditCatatanDialog(
                              context,
                              catatan['id'],
                              catatan['judul'],
                              catatan['deskripsi'],
                              catatan['tanggal']);
                        } else if (value == 'delete') {
                          hapusCatatan(catatan['id']);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                            
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddCatatanDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

extension StringCasingExtension on String {
  String get capitalizeFirst =>
      this.isEmpty ? this : '${this[0].toUpperCase()}${this.substring(1)}';
}
