import 'dart:io';

import 'package:ElMovie/app/modules/home/controllers/home_controller.dart';
import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../microphone/controllers/microphone_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final int _selectedIndex = 0;
  final MicrophoneController microphoneController =
      Get.find<MicrophoneController>();
  final TextEditingController searchController = TextEditingController();

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
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () {
                searchController.text = controller.searchQuery.value;
                searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: searchController.text.length),
                );

                return TextField(
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        microphoneController.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (microphoneController.isListening.value) {
                          microphoneController.stopListening();
                        } else {
                          microphoneController.startListening();
                        }
                      },
                    ),
                  ),
                  controller: searchController,
                  onChanged: (value) {
                    controller.searchQuery.value = value; // Trigger search
                  },
                );
              },
            ),
          ),
          Expanded(
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
                      elevation: 5,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
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
