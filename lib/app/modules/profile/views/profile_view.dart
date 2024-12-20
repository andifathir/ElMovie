import 'package:ElMovie/app/modules/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import 'package:get/get.dart'; // Import Get package for navigation

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          body: SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/BG_BELAKANG_MENU_PROFILE.png'), // Ensure the image path is correct
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                profileProvider.profileImage != null
                                    ? FileImage(profileProvider.profileImage!)
                                    : null,
                            child: profileProvider.profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileProvider.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showEditUsernameDialog(
                                      context, profileProvider);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await profileProvider.pickImage();
                        },
                        icon: const Icon(Icons.photo, color: Colors.black),
                        label: const Text('Change Profile Picture',
                            style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Your Archive',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActionButton('Booklist'),
                          const SizedBox(height: 10),
                          _buildActionButton('Review'),
                          const SizedBox(height: 10),
                          _buildActionButton('History'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAccountButton('Setting'),
                          const SizedBox(height: 10),
                          _buildAccountButton('Change Password'),
                        ],
                      ),
                      const SizedBox(height: 20),
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
        );
      },
    );
  }

  void _showEditUsernameDialog(
      BuildContext context, ProfileProvider profileProvider) {
    final TextEditingController controller =
        TextEditingController(text: profileProvider.username);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Username'),
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
                profileProvider.updateUsername(controller.text);
                profileProvider.saveProfileData();
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the login screen
                Navigator.of(context).pop(); // Close the dialog
                // Get.offAll(() => const LoginView()); // Navigate to login
                _authController.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 40),
      ),
      onPressed: () {
        debugPrint('$title button pressed');
      },
      child: Text(title),
    );
  }

  Widget _buildAccountButton(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        minimumSize: const Size(double.infinity, 40),
      ),
      onPressed: () {
        debugPrint('$title button pressed');
      },
      child: Text(title),
    );
  }
}
