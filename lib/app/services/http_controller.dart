import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart'; // Pastikan path ke model Movie sesuai

class HttpController extends GetxController {
  var movies = <Movie>[].obs; // Observable list of Movie objects
  var isLoading = true.obs; // Observable loading state

  Future<void> fetchMovies() async {
    const String url = 'https://imdb-top-100-movies.p.rapidapi.com/';
    final Map<String, String> headers = {
      'X-Rapidapi-Key': 'de32544bf8mshe986a608d72ae1cp15cb20jsna82e4d85aa39',
      'X-Rapidapi-Host': 'imdb-top-100-movies.p.rapidapi.com',
      'Content-Type': 'application/json',
    };

    try {
      isLoading(true); // Set loading state to true
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // Ambil hanya 5 film
        movies.value =
            jsonList.take(5).map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movie data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false); // Set loading state to false
    }
  }
}
