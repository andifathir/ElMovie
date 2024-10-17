import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/http_controller.dart';

class MovieView extends StatelessWidget {
  final HttpController movieController = Get.put(HttpController()); // Menggunakan HttpController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: Obx(() {
        if (movieController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (movieController.movies.isEmpty) {
          return Center(child: Text('No movies found'));
        } else {
          return ListView.builder(
            itemCount: movieController.movies.length,
            itemBuilder: (context, index) {
              final movie = movieController.movies[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(movie.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${movie.description}'),
                      Text('Year: ${movie.year}'),
                      Text('Rating: ${movie.rating}'),
                    ],
                  ),
                  leading: movie.thumbnail.isNotEmpty
                      ? Image.network(movie.thumbnail, width: 50, fit: BoxFit.cover)
                      : SizedBox(width: 50), // Placeholder for missing thumbnail
                  onTap: () {
                    // Handle navigation to movie detail page, if needed
                    // Get.to(() => MovieDetailView(movie: movie));
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          movieController.fetchMovies(); // Fetch movies when button is pressed
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
