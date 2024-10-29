import 'package:ElMovie/app/modules/login/views/login_view.dart';
import 'package:ElMovie/app/modules/navbar/views/navbar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Make form key and controllers public
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registerUser() async {
    if (formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Get.off((const LoginView())); // Uses GetX for navigation
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.message ?? "Registration failed");
      }
    }
  }

  Future<void> loginUser() async {
    if (formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Get.off((const NavbarView())); // Uses GetX for navigation
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.message ?? "Login failed");
      }
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAll(const LoginView());
  }
}
