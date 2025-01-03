import 'package:ElMovie/app/data/models/movie.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieController extends GetxController {
  var movies = <Movie>[].obs; // Observable list of Movie objects
  var isLoading = true.obs; // Observable loading state

  Future<void> fetchMovies() async {
    const String url = 'https://imdb-top-100-movies.p.rapidapi.com/';
    final Map<String, String> headers = {
      'X-Rapidapi-Key': '3ebf4effe6msh4ac2454edc605a4p11637fjsn37072de3335c',
      'X-Rapidapi-Host': 'imdb-top-100-movies.p.rapidapi.com',
      'Content-Type': 'application/json',
    };

    try {
      isLoading(true);
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // Limit to only the first 10 movies
        movies.value =
            jsonList.take(10).map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movie data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
