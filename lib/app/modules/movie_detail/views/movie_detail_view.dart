import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_detail_controller.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  final Movie movie;

  const MovieDetailView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieDetailController controller = Get.put(MovieDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Thumbnail
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: movie.thumbnail.isNotEmpty
                      ? Image.network(
                          movie.thumbnail,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child:
                              Icon(Icons.movie, size: 60, color: Colors.grey),
                        ),
                ),
              ),
              SizedBox(height: 16),

              // Movie Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Year: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${movie.year}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Rating: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${movie.rating}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        movie.description,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Favorite and Dislike Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => ElevatedButton.icon(
                        onPressed: () => controller.toggleFavorite(
                          movie.id,
                          movie.title,
                        ),
                        icon: Icon(
                          Icons.favorite,
                          color: controller.isFavorite.value
                              ? Colors.red
                              : Colors.white,
                        ),
                        label: Text('Favorite'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isFavorite.value
                              ? Colors.green
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      )),
                  Obx(() => ElevatedButton.icon(
                        onPressed: () => controller.toggleDislike(
                          movie.id,
                          movie.title,
                        ),
                        icon: Icon(
                          Icons.thumb_down,
                          color: controller.isDisliked.value
                              ? Colors.blue
                              : Colors.white,
                        ),
                        label: Text('Dislike'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isDisliked.value
                              ? Colors.red
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 20),

              // Action Buttons
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.REVIEW, arguments: movie);
                },
                icon: Icon(Icons.rate_review),
                label: Text('Add Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(
                    Routes.MOVIE_DETAILS_WEBVIEW,
                    arguments: movie,
                  );
                },
                icon: Icon(Icons.info),
                label: Text('Read More'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
