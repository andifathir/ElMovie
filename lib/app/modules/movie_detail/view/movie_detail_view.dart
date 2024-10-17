import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/movie.dart';
import '../controllers/movie_detail_controller.dart';
import 'movie_detail_web_view.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  final Movie movie;

  const MovieDetailView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/BG_BELAKANG_HOME.png'), // Ganti dengan path gambar asset yang sesuai
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten di atas gambar latar belakang
          SingleChildScrollView(  // Tambahkan SingleChildScrollView di sini
            child: Padding(
              padding: EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  movie.thumbnail.isNotEmpty
                      ? Image.network(movie.thumbnail, height: 300, fit: BoxFit.cover)
                      : const SizedBox(
                          height: 200,
                          child: Placeholder()), // Placeholder for missing thumbnail
                  SizedBox(height: 16),
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), // Warna teks bisa disesuaikan
                  ),
                  SizedBox(height: 8),
                  Text('Description: ${movie.description}', style: TextStyle(fontSize: 13, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Year: ${movie.year}', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 236, 137, 0))),
                  SizedBox(height: 4),
                  Text('Rating: ${movie.rating}', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 236, 137, 0))),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Watch Now'),
                    onPressed: () {
                      Get.to(() => MovieDetailWebView(movie: movie));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
