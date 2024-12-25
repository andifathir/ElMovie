import 'package:ElMovie/app/modules/catatan/controller/catatan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class CatatanView extends GetView<CatatanController> {
  const CatatanView({super.key});

  Future<void> showAddCatatanDialog(BuildContext context) async {
    String judul = '';
    String deskripsi = '';
    String tanggal = DateFormat('d MMMM yyyy').format(DateTime.now());
    final player = AudioPlayer();

    await showDialog<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add List'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => judul = value,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      onChanged: (value) => deskripsi = value,
                      decoration: const InputDecoration(hintText: 'Deskription'),
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
                            hintText: 'Date: $tanggal',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (judul.isNotEmpty && deskripsi.isNotEmpty) {
                        controller.tambahCatatan(judul, deskripsi, tanggal);
                        Navigator.of(context).pop();

                        // Show success popup
                        Get.snackbar(
                          'Berhasil',
                          'Catatan berhasil ditambahkan!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        // Play success sound
                        player.play(AssetSource('success.mp3'));
                      }
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cencel'),
                  ),
                ],
              );
            },
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
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Catatan'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      controller: deskripsiController,
                      decoration: const InputDecoration(hintText: 'Deskription'),
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
                            hintText: 'Date: $selectedDate',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (judulController.text.isNotEmpty &&
                          deskripsiController.text.isNotEmpty) {
                        controller.updateCatatan(id, judulController.text,
                            deskripsiController.text, selectedDate);
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
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/BG_BELAKANG_HOME.png', // Replace with your actual path
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Watch Lists Film',
              style: TextStyle(
                fontSize: 22, // Increased font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () =>  showAddCatatanDialog(context),
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Review', // Tooltip for better UX
              ),
              const SizedBox(width: 10), // Space between the icon and the edge
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Obx(() {
            return ListView.builder(
              itemCount: controller.catatanList.length,
              itemBuilder: (context, index) {
                final catatan = controller.catatanList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        catatan['judul'] ?? 'No Title',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catatan['deskripsi'] ?? 'No Description',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Tanggal: ${catatan['tanggal'] ?? 'Tanggal tidak tersedia'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                            controller.hapusCatatan(catatan['id']);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<String>(
                                value: 'edit', child: Text('Edit')),
                            const PopupMenuItem<String>(
                                value: 'delete', child: Text('Delete')),
                          ];
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
