import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final List<File> _capturedMediaList = [];
  final List<Map<String, dynamic>> _reviews = [];
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  // Untuk menyimpan rating yang dipilih
  double selectedRating = 1.0;

  Future<void> _captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final imageFile = File(image.path);
      await _showReviewDialog(imageFile);
    }
  }

  Future<void> _captureVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      final videoFile = File(video.path);
      _videoController = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setLooping(true);
        }).catchError((e) {
          print('Error initializing video: $e');
        });

      await _showReviewDialog(videoFile);
    }
  }

  Future<void> _showReviewDialog(File mediaFile) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController reviewController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Add a Review', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter movie title...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Rating:', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  DropdownButton<double>(
                    value: selectedRating,
                    dropdownColor: Colors.black,
                    style: TextStyle(color: Colors.white),
                    items: [
                      for (var i = 1; i <= 5; i++)
                        DropdownMenuItem(
                          value: i.toDouble(),
                          child: Text('$i'),
                        ),
                    ],
                    onChanged: (double? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRating = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextField(
                controller: reviewController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your review...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                final titleText = titleController.text;
                final reviewText = reviewController.text;
                if (titleText.isNotEmpty && reviewText.isNotEmpty) {
                  setState(() {
                    _capturedMediaList.add(mediaFile);
                    _reviews.add({
                      'title': titleText,
                      'rating': selectedRating,
                      'review': reviewText,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Upload', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      if (_isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } else {
      print('Video not initialized');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/BG_BELAKANG_MENU_PROFILE.png'), // Ganti dengan path aset Anda
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Review Film', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _capturedMediaList.length,
                itemBuilder: (context, index) {
                  final mediaFile = _capturedMediaList[index];
                  final isVideo = mediaFile.path.endsWith('.mp4');
                  final review = _reviews[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.grey[900]?.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
                            ),
                            child: isVideo
                                ? _videoController != null &&
                                        _videoController!.value.isInitialized
                                    ? GestureDetector(
                                        onTap: _togglePlayPause,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: VideoPlayer(_videoController!),
                                        ),
                                      )
                                    : Center(child: CircularProgressIndicator())
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      mediaFile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            review['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rating: ${review['rating']}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            review['review'],
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _captureImage,
            tooltip: 'Capture Image',
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.purple,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _captureVideo,
            tooltip: 'Capture Video',
            child: Icon(Icons.videocam),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
