import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker _picker = ImagePicker();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    String? imagePath = _prefs?.getString('profileImage');
    String username = _prefs?.getString('username') ?? "User";

    // Update ProfileProvider
    Provider.of<ProfileProvider>(context, listen: false).updateUsername(username);

    if (imagePath != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateProfileImage(File(imagePath));
    }
  }

  Future<void> _saveProfileData() async {
    if (_prefs != null) {
      await _prefs!.setString('username', Provider.of<ProfileProvider>(context, listen: false).username);
      File? profileImage = Provider.of<ProfileProvider>(context, listen: false).profileImage;
      if (profileImage != null) {
        await _prefs!.setString('profileImage', profileImage.path);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateProfileImage(File(pickedFile.path));
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
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
                    backgroundImage: profileProvider.profileImage != null
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
                          _showEditUsernameDialog();
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
                onPressed: _pickImage,
                icon: const Icon(Icons.photo, color: Colors.black),
                label: const Text('Change Profile Picture', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 30),

              // Teks "Your Arsip"
              const Text(
                'Your Arsip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // List untuk Booklist, Review, dan History
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
              const SizedBox(height: 30), // Spasi sebelum bagian Account

              // Teks "Account"
              const Text(
                'Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Tombol untuk Setting dan Change Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccountButton('Setting'),
                  const SizedBox(height: 10),
                  _buildAccountButton('Change Password'),
                ],
              ),
              const SizedBox(height: 20), // Spasi sebelum tombol Logout

              // Tombol Logout
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Warna tombol logout
                  ),
                  onPressed: () {
                    // Logika logout
                    debugPrint('Logout button pressed');
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditUsernameDialog() {
    final TextEditingController controller = TextEditingController(text: Provider.of<ProfileProvider>(context, listen: false).username);

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
                Provider.of<ProfileProvider>(context, listen: false).updateUsername(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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
