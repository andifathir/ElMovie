import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

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
            title: const Text('Review Film',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Obx(() {
            return ListView.builder(
              itemCount: controller.reviewList.length,
              itemBuilder: (context, index) {
                final review = controller.reviewList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.grey[850], // Black with a slightly grey tone
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review['imagePath'] != '')
                        review['imagePath'].endsWith('.mp4')
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(() => VideoPlayerScreen(
                                      filePath: review['imagePath']));
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    color: Colors.black,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.play_circle_fill,
                                        color: Colors.white, size: 50),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.file(
                                  File(review['imagePath']),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['movieName'] ?? 'No Title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rating: ${review['rating'] ?? ''}/5',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['review'] ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditReviewDialog(
                                context,
                                review['id'],
                                review['movieName'],
                                review['rating'],
                                review['review'],
                                review['imagePath'],
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              controller.deleteReview(review['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddReviewDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final movieNameController = TextEditingController();
    final ratingController = TextEditingController();
    final reviewController = TextEditingController();
    File? selectedMedia;

    Get.dialog(
      AlertDialog(
        title: Text("Add Review"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: movieNameController,
                decoration: InputDecoration(labelText: "Movie Name"),
              ),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: "Rating (out of 5)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(labelText: "Review"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  File? media = await controller.pickImageFromGallery();
                  if (media != null) {
                    selectedMedia = media;
                    Get.snackbar('Media Selected', 'Selected from Gallery');
                  }
                },
                icon: Icon(Icons.photo),
                label: Text("Pick from Gallery"),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  File? media = await controller.takePhotoOrVideo();
                  if (media != null) {
                    selectedMedia = media;
                    Get.snackbar('Media Selected', 'Captured from Camera');
                  }
                },
                icon: Icon(Icons.camera_alt),
                label: Text("Take Photo/Video"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (movieNameController.text.isEmpty ||
                  ratingController.text.isEmpty ||
                  reviewController.text.isEmpty ||
                  selectedMedia == null) {
                Get.snackbar('Error', 'All fields and media are required!');
                return;
              }
              controller.addReview(
                movieNameController.text,
                double.tryParse(ratingController.text) ?? 0.0,
                reviewController.text,
                selectedMedia,
              );
              Get.back();
            },
            child: Text("Add"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, String id, String? movieName,
      double? rating, String? reviewText, String? imagePath) {
    final movieNameController = TextEditingController(text: movieName);
    final ratingController =
        TextEditingController(text: rating?.toStringAsFixed(1));
    final reviewController = TextEditingController(text: reviewText);
    File? selectedMedia = imagePath != null ? File(imagePath) : null;

    Get.dialog(
      AlertDialog(
        title: Text("Edit Review"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: movieNameController,
                decoration: InputDecoration(labelText: "Movie Name"),
              ),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: "Rating (out of 5)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(labelText: "Review"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  File? media = await controller.pickImageFromGallery();
                  if (media != null) {
                    selectedMedia = media;
                    Get.snackbar('Media Updated', 'Selected new media');
                  }
                },
                icon: Icon(Icons.photo),
                label: Text("Pick New Media"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (movieNameController.text.isEmpty ||
                  ratingController.text.isEmpty ||
                  reviewController.text.isEmpty) {
                Get.snackbar('Error', 'All fields are required!');
                return;
              }
              controller.updateReview(
                id,
                movieNameController.text,
                double.tryParse(ratingController.text) ?? 0.0,
                reviewController.text,
                selectedMedia,
              );
              Get.back();
            },
            child: Text("Update"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String filePath;

  const VideoPlayerScreen({required this.filePath, Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
