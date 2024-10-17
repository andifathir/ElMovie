import 'package:get/get.dart';
import '../../../models/movie.dart';
import '../../../services/http_controller.dart';

class HomeController extends GetxController {
  final HttpController movieController = Get.put(HttpController());

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  void fetchMovies() {
    movieController.fetchMovies();
  }

  bool get isLoading => movieController.isLoading.value;
  List<Movie> get movies => movieController.movies;
}
