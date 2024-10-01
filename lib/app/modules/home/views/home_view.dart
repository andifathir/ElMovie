import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/profile/views/profile_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// Import halaman ProfileView

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // Indeks untuk menandai tab yang dipilih
  File? _profileImage; // File yang akan menyimpan gambar profil yang dipilih
  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

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

  // Fungsi untuk menampilkan halaman berdasarkan tab yang dipilih
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildMovieRecommendations();
      default:
        return _buildMovieRecommendations();
    }
  }

  // Widget halaman rekomendasi film dengan foto profil di AppBar
  Widget _buildMovieRecommendations() {
    return Scaffold(
      backgroundColor: Colors.black, // Set background menjadi hitam
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png', // Ganti dengan path gambar logo Anda
          fit: BoxFit.contain,
          height: 25, // Atur tinggi gambar sesuai kebutuhan
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            // Tampilkan gambar profil di kanan AppBar
            child: GestureDetector(
              onTap: () {
                // Arahkan ke halaman profil saat gambar profil diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 14,
                        color: Colors.white, // Set warna ikon menjadi putih
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
          body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Container(
              width: 50,
              height: 150,
              child: Transform.scale(
                scale: 2.6,
                child: Image.asset(
                  'assets/The_Last_Knight.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'Transformers: The Last Knight',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'A deadly threat from Earth\'s history reappears and a hunt for a lost artifact takes place between Autobots and Decepticons, while Optimus Prime encounters his creator in space.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 150,
              child: Transform.scale(
                scale: 2.6,
                child: Image.asset(
                  'assets/SEAL_Team.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'SEAL Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'The lives of the elite Navy SEALs as they train, plan, and execute the most dangerous, high-stakes missions the United States of America can ask.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 150,
              child: Transform.scale(
                scale: 2.6,
                child: Image.asset(
                  'assets/The_Dark_Knight.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'The Dark Knight',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 150,
              child: Transform.scale(
                scale: 2.6,
                child: Image.asset(
                  'assets/Avengers_ Infinity_War.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'Avengers: Infinity War',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin:
                      const EdgeInsets.only(left: 20), // Menambahkan margin ke kiri
                  child: const Text(
                    'The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex), // Menampilkan halaman berdasarkan tab 
    );
  }
}
