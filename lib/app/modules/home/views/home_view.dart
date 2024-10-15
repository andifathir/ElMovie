import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
import 'package:ElMovie/app/modules/profile/providers/profile_provider.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final int _selectedIndex = 0;
  final MovieController movieController = Get.put(MovieController());

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildMovieRecommendations();
      default:
        return _buildMovieRecommendations();
    }
  }

  Widget _buildMovieRecommendations() {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          height: 25,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundImage: profileProvider.profileImage != null
                        ? FileImage(profileProvider.profileImage!)
                        : null,
                    child: profileProvider.profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
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
                      Text('Year: ${movie.year}'),
                      Text('Rating: ${movie.rating}'),
                      Text('Description: ${movie.description}'),
                    ],
                  ),
                  leading: movie.thumbnail.isNotEmpty
                      ? Image.network(movie.thumbnail,
                          width: 50, fit: BoxFit.cover)
                      : SizedBox(
                          width: 50), // Placeholder for missing thumbnail
                  onTap: () {
                    // Handle navigation to movie detail page, if needed
                    // Get.to(() => MovieDetailView(movie: movie));
                    Get.toNamed(Routes.MOVIE_DETAILS, arguments: movie);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/BG_BELAKANG_HOME.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildPage(_selectedIndex),
      ),
    );
  }
}
