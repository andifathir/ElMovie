import 'package:ElMovie/app/data/services/http_controller.dart';
import 'package:ElMovie/app/modules/home/controllers/home_controller.dart';
import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:ElMovie/app/modules/profile/views/profile_view.dart';
import 'package:ElMovie/app/modules/profile/providers/profile_provider.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

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
            child: MouseRegion(
              cursor: SystemMouseCursors.click, // Change cursor on hover
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      () => ProfileView()); // Use Get.to instead of Navigator
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
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/BG_BELAKANG_HOME.png'), // Use the path to your image
            fit: BoxFit.cover, // Adjust to cover the entire container
          ),
        ),
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.movies.isEmpty) {
            return const Center(
                child: Text('No movies found',
                    style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              itemCount: controller.movies.length,
              itemBuilder: (context, index) {
                final movie = controller.movies[index];
                return Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      movie.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${movie.description}',
                            style: const TextStyle(color: Colors.white)),
                        Text('Year: ${movie.year}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 236, 137, 0))),
                        Text('Rating: ${movie.rating}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 236, 137, 0))),
                      ],
                    ),
                    leading: SizedBox(
                      width: 100,
                      height: 150,
                      child: movie.thumbnail.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(1.0),
                              child: Image.network(
                                movie.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image, size: 100),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.MOVIE_DETAILS, arguments: movie);
                    },
                  ),
                );
              },
            );
          }
        }),
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
