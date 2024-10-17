import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileController with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  SharedPreferences? _prefs;

  String username = "User";
  File? profileImage;

  ProfileController() {
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    username = _prefs?.getString('username') ?? "User";
    String? imagePath = _prefs?.getString('profileImage');

    if (imagePath != null) {
      profileImage = File(imagePath);
    }
    notifyListeners();
  }

  Future<void> saveProfileData() async {
    if (_prefs != null) {
      await _prefs!.setString('username', username);
      if (profileImage != null) {
        await _prefs!.setString('profileImage', profileImage!.path);
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    } else {
      debugPrint('No image selected.');
    }
  }

  void updateUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }
}
