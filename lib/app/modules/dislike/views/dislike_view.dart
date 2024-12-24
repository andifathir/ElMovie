import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dislike_controller.dart';

class DislikeView extends GetView<DislikeController> {
  const DislikeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DislikeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DislikeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
