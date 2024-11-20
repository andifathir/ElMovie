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
  final List<String> _reviews = [];
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

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
    final TextEditingController reviewController = TextEditingController();

    await showDialog<void>(context: context, builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Add a Review', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: reviewController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your review...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
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
              final reviewText = reviewController.text;
              if (reviewText.isNotEmpty) {
                setState(() {
                  _capturedMediaList.add(mediaFile);
                  _reviews.add(reviewText);
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Upload', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    });
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
      appBar: AppBar(
        title: Text('Review Film', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Menambahkan warna latar belakang app bar
      ),
      backgroundColor: Colors.black, // Menambahkan warna latar belakang Scaffold
      body: ListView.builder(
        itemCount: _capturedMediaList.length,
        itemBuilder: (context, index) {
          final mediaFile = _capturedMediaList[index];
          final isVideo = mediaFile.path.endsWith('.mp4');

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isVideo
                    ? _videoController != null &&
                            _videoController!.value.isInitialized
                        ? Container(
                            height: 200,
                            width: 200,
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: VideoPlayer(_videoController!),
                            ),
                          )
                        : Center(child: CircularProgressIndicator())
                    : Image.file(
                        mediaFile,
                        height: 200, // Set the height of the image to match the video
                        width: 200, // Set the width to match the video
                        fit: BoxFit.cover,
                      ),
                SizedBox(height: 16), // Increase the gap between media items
                Text(
                  _reviews[index],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _captureImage,
            tooltip: 'Capture Image',
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.purple, // Menambahkan warna tombol FAB
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _captureVideo,
            tooltip: 'Capture Video',
            child: Icon(Icons.videocam),
            backgroundColor: Colors.purple, // Menambahkan warna tombol FAB
          ),
        ],
      ),
    );
  }
}
