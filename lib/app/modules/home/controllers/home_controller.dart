import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final MovieController movieController = Get.put(MovieController());

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchMovies() {
    movieController.fetchMovies();
  }

  bool get isLoading => movieController.isLoading.value;
  List<Movie> get movies => movieController.movies;
}
