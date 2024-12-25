import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final MovieController movieController = Get.put(MovieController());

  var searchQuery = ''.obs;
  var filteredMovies = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
    ever(searchQuery, (_) => searchMovies(searchQuery.value));
  }

  void fetchMovies() async {
    await movieController.fetchMovies();
    filteredMovies.assignAll(movieController.movies);
  }

  void searchMovies(String query) {
    query = query.trim();

    if (query.isEmpty) {
      filteredMovies.assignAll(movieController.movies);
    } else {
      final matches = movieController.movies.where(
          (movie) => movie.title.toLowerCase().contains(query.toLowerCase()));
      filteredMovies.assignAll(matches);

      if (filteredMovies.isEmpty) {
        Get.snackbar('MOVIE NOT FOUND', 'No matching movies for "$query"',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  bool get isLoading => movieController.isLoading.value;
  List<Movie> get movies => filteredMovies;
}
