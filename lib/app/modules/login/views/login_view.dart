import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/home/views/home_view.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
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

  Future<String?> _signupUser(SignupData data) async {
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

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(name)) {
      return 'User does not exist';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Add initial test data for testing purposes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('test@gmail.com')) {
        await prefs.setString('test@gmail.com', 'test123');
        debugPrint('Test user added: test@gmail.com with password test123');
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG BELAKANG.png'), // Path to your background image
            fit: BoxFit.cover, // Ensure the image covers the entire background
          ),
        ),
        child: FlutterLogin(
          logo: const AssetImage('assets/logo.png'),
          onLogin: (data) async {
            // Handle login
            String? result = await _authUser(data);
            if (result == null) {
              // Navigate to HomeView on successful login
              debugPrint('Login successful');
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeView(),
              ));
            }
            return result; // This will return error messages if login fails
          },
          onSignup: (data) async {
            // Handle sign up
            String? result = await _signupUser(data);
            if (result == null) {
              // Sign-up successful, do not navigate yet
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginView(),
              ));
            }
            return result; // This will return error messages if sign up fails
          },
          onRecoverPassword: _recoverPassword,
          theme: LoginTheme(
            primaryColor: Colors.transparent, // Make the primary color transparent
            pageColorLight: Colors.transparent, // Make the page color transparent
            pageColorDark: Colors.transparent, // Make the page color transparent
            buttonTheme: const LoginButtonTheme(
              backgroundColor: Color.fromARGB(255, 88, 99, 220), // Button background color
              highlightColor: Colors.purple, // Button highlight color
            ),
            cardTheme: CardTheme(
              color: const Color.fromARGB(255, 171, 124, 230),
              elevation: 5,
              margin: const EdgeInsets.only(top: 15),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ), // Card background color
            ),
          ),
        ),
      ),
    );
  }
}