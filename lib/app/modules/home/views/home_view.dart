import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // Indeks untuk menandai tab yang dipilih
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
      debugPrint('Selected image path: ${pickedFile.path}');
    } else {
      debugPrint('No image selected.');
    }
  }

  // Fungsi untuk menampilkan halaman berdasarkan tab yang dipilih
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildMovieRecommendations();
      case 1:
        return _buildProfilePage();
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
        ],
      ),
    );
  }

  // Widget halaman profil
  Widget _buildProfilePage() {
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

  // Fungsi untuk menangani perubahan tab di BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex), // Menampilkan halaman berdasarkan tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Set background navbar menjadi hitam
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie,
                color: Colors.white), // Set ikon menjadi putih
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: Colors.white), // Set ikon menjadi putih
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent, // Warna item yang dipilih
        unselectedItemColor: Colors.white70, // Warna item yang tidak dipilih
        onTap: _onItemTapped, // Mengganti halaman saat tab ditekan
      ),
    );
  }
}
