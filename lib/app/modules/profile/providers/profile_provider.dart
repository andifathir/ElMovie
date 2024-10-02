import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  File? _profileImage;
  String _username = "User";
  SharedPreferences? _prefs;

  ProfileProvider() {
    _loadProfileData(); // Load data saat pertama kali dipanggil
  }

  File? get profileImage => _profileImage;
  String get username => _username;

  // Load profile data dari SharedPreferences
  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    _username = _prefs?.getString('username') ?? "User";
    String? imagePath = _prefs?.getString('profileImage');
    if (imagePath != null) {
      _profileImage = File(imagePath);
    }
    notifyListeners(); // Notifikasi listener setelah data diload
  }

  // Update profile image
  Future<void> updateProfileImage(File image) async {
    _profileImage = image;
    notifyListeners();
    await _prefs?.setString('profileImage', _profileImage!.path); // Simpan path ke SharedPreferences
  }

  // Update username
  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    notifyListeners();
    await _prefs?.setString('username', _username); // Simpan username ke SharedPreferences
  }
}
