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
        children: const [
          ListTile(
            leading: Icon(Icons.movie,
                color: Colors.white), // Set ikon menjadi putih
            title: Text('Inception',
                style:
                    TextStyle(color: Colors.white)), // Set teks menjadi putih
            subtitle: Text('A mind-bending thriller by Christopher Nolan.',
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            leading: Icon(Icons.movie, color: Colors.white),
            title: Text('Interstellar', style: TextStyle(color: Colors.white)),
            subtitle: Text(
                'A science fiction epic that takes you beyond the stars.',
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            leading: Icon(Icons.movie, color: Colors.white),
            title:
                Text('The Dark Knight', style: TextStyle(color: Colors.white)),
            subtitle: Text(
                'The iconic Batman movie directed by Christopher Nolan.',
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            leading: Icon(Icons.movie, color: Colors.white),
            title: Text('The Matrix', style: TextStyle(color: Colors.white)),
            subtitle: Text(
                'A revolutionary sci-fi film about artificial reality.',
                style: TextStyle(color: Colors.white70)),
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
