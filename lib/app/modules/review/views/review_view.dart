import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
            title: const Text(
              'Review Film',
              style: TextStyle(
                fontSize: 22, // Increased font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => _showAddReviewDialog(context),
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Review', // Tooltip for better UX
              ),
              const SizedBox(width: 10), // Space between the icon and the edge
            ],
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
                      Stack(
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
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                          Positioned(
                            top:
                                10, // Positioning the button just below the image
                            right: 10, // Aligning to the top-right corner
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditReviewDialog(
                                    context,
                                    review['id'],
                                    review['movieName'],
                                    review['rating'],
                                    review['review'],
                                    review['imagePath'],
                                  );
                                } else if (value == 'delete') {
                                  controller.deleteReview(review['id']);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: const [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('Edit',
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: const [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ),
                        ],
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
                            // Rating Stars
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < (review['rating']?.toInt() ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                  size: 18,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['review'] ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // Inside your ReviewView widget
// Inside your ReviewView widget
  void _showAddReviewDialog(BuildContext context) {
    final movieNameController = TextEditingController();
    final reviewController = TextEditingController();
    File? selectedMedia;
    double rating = 0.0; // Store the selected rating

    // Use a StatefulWidget to allow the UI to rebuild when rating changes
    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
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
                    controller: reviewController,
                    decoration: InputDecoration(labelText: "Review"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  // Rating text above the stars, updates as rating changes
                  Text("Rating: ${rating.toStringAsFixed(1)}"),
                  const SizedBox(height: 5),
                  // Smaller star rating
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30, // Smaller stars
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating; // Update rating value
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      File? media = await controller.pickImageFromGallery();
                      if (media != null) {
                        selectedMedia = media;
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
                      reviewController.text.isEmpty ||
                      selectedMedia == null) {
                    Get.snackbar('Error', 'All fields and media are required!');
                    return;
                  }
                  controller.addReview(
                    movieNameController.text,
                    rating,
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
          );
        },
      ),
    );
  }

// Similarly update the edit review dialog
  void _showEditReviewDialog(BuildContext context, String id, String? movieName,
      double? rating, String? reviewText, String? imagePath) {
    final movieNameController = TextEditingController(text: movieName);
    final reviewController = TextEditingController(text: reviewText);
    File? selectedMedia = imagePath != null ? File(imagePath) : null;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
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
                    controller: reviewController,
                    decoration: InputDecoration(labelText: "Review"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  // Rating text above the stars, updates as rating changes
                  Text("Rating: ${rating?.toStringAsFixed(1) ?? '0.0'}"),
                  const SizedBox(height: 5),
                  // Smaller star rating
                  RatingBar.builder(
                    initialRating: rating ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30, // Smaller stars
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating; // Update rating value
                      });
                    },
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
                      reviewController.text.isEmpty) {
                    Get.snackbar('Error', 'All fields are required!');
                    return;
                  }
                  controller.updateReview(
                    id,
                    movieNameController.text,
                    rating ?? 0.0,
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
          );
        },
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
