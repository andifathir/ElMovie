import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dislike_controller.dart';

class DislikeView extends GetView<DislikeController> {
  const DislikeView({super.key});

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
                const Text('Dislikes', style: TextStyle(color: Colors.white)),
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

            if (controller.dislikes.isEmpty) {
              return const Center(
                child: Text(
                  'No disliked movies yet',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.dislikes.length,
              itemBuilder: (context, index) {
                final movie = controller.dislikes[index];
                return Card(
                  color: Colors.grey.withOpacity(0.8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.movie, color: Colors.red[700]),
                    title: Text(
                      movie['movieName'] ??
                          'Unknown Title', // Display only movieName
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
