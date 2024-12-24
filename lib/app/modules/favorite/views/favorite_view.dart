import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/BG_BELAKANG_HOME.png', // Replace with your actual path
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title:
                const Text('Favorites', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.favorites.isEmpty) {
              return const Center(
                child: Text(
                  'No favorite movies yet',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.favorites.length,
              itemBuilder: (context, index) {
                final movie = controller.favorites[index];
                return Card(
                  color: Colors.white.withOpacity(0.8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.movie, color: Colors.blueGrey[700]),
                    title: Text(movie['title'] ?? 'Unknown Title'),
                    subtitle: Text(movie['description'] ?? 'No description'),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
