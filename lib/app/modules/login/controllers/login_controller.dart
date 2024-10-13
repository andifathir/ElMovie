import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginController extends GetxController {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString(data.name);

    if (storedPassword == null) {
      return 'User does not exist';
    }
    if (storedPassword != data.password) {
      return 'Password does not match';
    }
    return null; // Successful login
  }

  Future<String?> signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    final prefs = await SharedPreferences.getInstance();

    // Check if the user already exists
    if (prefs.containsKey(data.name!)) {
      return 'This email is already registered';
    }

    // Save the new user's email and password
    await prefs.setString(data.name!, data.password!);
    debugPrint('User ${data.name} registered successfully.');
    return null; // Sign-up success
  }

  Future<String?> recoverPassword(String name) async {
    debugPrint('Name: $name');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(name)) {
      return 'User does not exist';
    }
    return null;
  }

  // Initialize test data
  Future<void> addTestData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('test@gmail.com')) {
      await prefs.setString('test@gmail.com', 'test123');
      debugPrint('Test user added: test@gmail.com with password test123');
    }
  }
}
