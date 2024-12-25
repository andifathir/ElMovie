import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/BG_BELAKANG_MENU_PROFILE.png', // Replace with the correct path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height - kToolbarHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Row(
                        children: [
                          Obx(() => GestureDetector(
                                onTap: () async {
                                  await profileController.pickProfileImage();
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: profileController
                                              .profileImage.value !=
                                          null
                                      ? FileImage(
                                          profileController.profileImage.value!)
                                      : (profileController.profileData[
                                                      'imagePath'] !=
                                                  null &&
                                              profileController
                                                  .profileData['imagePath']
                                                  .isNotEmpty
                                          ? FileImage(File(profileController
                                              .profileData['imagePath']))
                                          : null),
                                  child: profileController.profileImage.value ==
                                              null &&
                                          (profileController.profileData[
                                                      'imagePath'] ==
                                                  null ||
                                              profileController
                                                  .profileData['imagePath']
                                                  .isEmpty)
                                      ? const Icon(Icons.person,
                                          size: 50, color: Colors.white)
                                      : null,
                                ),
                              )),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Text(
                                          profileController
                                                  .profileData['username'] ??
                                              'No Name',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.white, size: 20),
                                      onPressed: () {
                                        _showEditDialog(
                                          context,
                                          'Edit Username',
                                          'Username',
                                          profileController
                                                  .profileData['username'] ??
                                              '',
                                          (value) {
                                            profileController.updateProfile(
                                                value,
                                                profileController.profileData[
                                                        'favoriteGenre'] ??
                                                    '');
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Genre Preference',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              _showEditDialog(
                                context,
                                'Edit Favorite Genre',
                                'Favorite Genre',
                                profileController
                                        .profileData['favoriteGenre'] ??
                                    '',
                                (value) {
                                  profileController.updateProfile(
                                      profileController
                                              .profileData['username'] ??
                                          '',
                                      value);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                            profileController.profileData['favoriteGenre'] ??
                                'No Genre',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          )),
                      const SizedBox(height: 50),
                      _buildActionButton('Watchlist', () {
                        Get.toNamed(
                            '/CatatanView'); // Navigate to the Watchlist page
                      }),
                      const SizedBox(height: 20),
                      _buildActionButton('Favorites', () {
                        Get.toNamed(
                            '/favorite'); // Navigate to the Favorites page
                      }),
                      const SizedBox(height: 20),
                      _buildActionButton('Disliked Movies', () {
                        Get.toNamed(
                            '/dislike'); // Navigate to the Disliked Movies page
                      }),
                      const SizedBox(height: 45),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _showLogoutConfirmationDialog(context);
                          },
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, String fieldLabel,
      String initialValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: fieldLabel),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                profileController.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF5963DC),
        minimumSize: const Size(double.infinity, 40),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
