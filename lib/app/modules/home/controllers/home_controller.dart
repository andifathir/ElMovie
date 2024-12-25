import 'dart:io';
import 'package:get/get.dart';
import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final MovieController movieController = Get.put(MovieController());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isConnected = true.obs;

  var searchQuery = ''.obs; // Reactive variable for search query
  var filteredMovies = <Movie>[].obs; // Reactive list for filtered movies

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
    fetchMovies(); // Load movies
    ever(profileData, (_) {
      // Update profile data when it changes
      _loadProfileData(); // Reload profile data from Firestore
    });
    ever(profileImage, (_) {
      // Update profile image when it changes
      _loadProfileData(); // Reload profile data from Firestore
    });
  }

  String? get uid => auth.currentUser?.uid;

  Future<void> _loadProfileData() async {
    if (uid == null) return;

    try {
      final DocumentSnapshot profileDoc = await firestore
          .collection('users')
          .doc(uid)
          .collection('Profile')
          .doc('main')
          .get();

      if (profileDoc.exists) {
        profileData.assignAll(profileDoc.data() as Map<String, dynamic>);
        if (profileData['imagePath'] != null &&
            profileData['imagePath'].isNotEmpty) {
          profileImage.value = File(profileData['imagePath']);
        }
      } else {
        profileData.clear();
        profileImage.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data: $e');
    }
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
