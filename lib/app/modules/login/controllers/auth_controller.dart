import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isPasswordVisible = false.obs;

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
        Get.offNamed(Routes.LOGIN);
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
        Get.offNamed(Routes.NAVBAR);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.message ?? "Login failed");
      }
    }
  }

void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
