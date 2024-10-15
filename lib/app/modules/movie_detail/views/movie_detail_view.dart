import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/modules/movie_detail/views/movie_detail_web_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_detail_controller.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  final Movie movie;

  const MovieDetailView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.thumbnail.isNotEmpty
                ? Image.network(movie.thumbnail, height: 200, fit: BoxFit.cover)
                : SizedBox(
                    height: 200,
                    child: Placeholder()), // Placeholder for missing thumbnail
            SizedBox(height: 16),
            Text(
              movie.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Year: ${movie.year}'),
            SizedBox(height: 4),
            Text('Rating: ${movie.rating}'),
            SizedBox(height: 4),
            Text('Description: ${movie.description}'),
            Spacer(),
            ElevatedButton(
              child: const Text('Read more'),
              onPressed: () {
                Get.to(() => MovieDetailWebView(movie: movie));
              },
            )
          ],
        ),
      ),
    );
  }
}
