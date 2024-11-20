import 'package:get/get.dart';
import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/data/services/http_controller.dart';

class HomeController extends GetxController {
  final MovieController movieController = Get.put(MovieController());

  var searchQuery = ''.obs; // Reactive variable for search query
  var filteredMovies = <Movie>[].obs; // Reactive list for filtered movies

  @override
  void onInit() {
    super.onInit();
    fetchMovies(); // Load movies
    ever(searchQuery,
        (_) => searchMovies(searchQuery.value)); // Monitor query changes
  }

  void fetchMovies() async {
    await movieController.fetchMovies();
    filteredMovies
        .assignAll(movieController.movies); // Display all movies initially
    print('Movies fetched: ${movieController.movies.length}');
  }

  void searchMovies(String query) {
    query = query.trim(); // Remove leading and trailing spaces

    if (query.isEmpty) {
      // If search query is empty, display all movies
      filteredMovies.assignAll(movieController.movies);
    } else {
      // Filter movies based on the query
      final matches = movieController.movies.where(
          (movie) => movie.title.toLowerCase().contains(query.toLowerCase()));

      filteredMovies.assignAll(matches);

      // If no matches found, show notification
      if (filteredMovies.isEmpty) {
        Get.snackbar('MOVIE NOT FOUND', 'No matching movies for "$query"',
            snackPosition: SnackPosition.BOTTOM);
      }
    }

    print('Search query: $query');
    print('Filtered movies: ${filteredMovies.length}');
  }

  bool get isLoading => movieController.isLoading.value;
  List<Movie> get movies => filteredMovies; // Displayed movie list
}
