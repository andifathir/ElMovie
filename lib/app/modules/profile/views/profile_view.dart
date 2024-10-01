import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _profileImage; // File yang akan menyimpan gambar profil yang dipilih
  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker
  String _username = "User"; // Variabel untuk menyimpan username

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Set gambar yang dipilih
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background menjadi hitam
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Widget untuk menampilkan gambar profil
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white, // Set ikon menjadi putih
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            // Tampilkan username di bawah foto profil
            Text(
              _username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            // TextField untuk mengedit username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Edit Username',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label berwarna putih
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white), // Garis bawah putih
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.blueAccent), // Garis bawah biru saat fokus
                  ),
                ),
                style:
                    const TextStyle(color: Colors.white), // Teks berwarna putih
                onChanged: (value) {
                  setState(() {
                    _username = value; // Set username saat diubah
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Tombol untuk memilih gambar dari galeri
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Set warna teks tombol
              ),
              onPressed: _pickImage,
              icon: const Icon(Icons.photo, color: Colors.black),
              label: const Text('Change Profile Picture',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
