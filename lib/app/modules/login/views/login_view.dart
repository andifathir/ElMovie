import 'package:ElMovie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/BG_BELAKANG.png', // Ensure this file exists in assets
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for better readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Login Form Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/Logo Awal Splash Screen.png', // Ensure this file exists in assets
                      height: 250,
                    ),
                    const SizedBox(height: 16),
                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Form
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: controller.emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter an email' : null,
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          Obx(() => TextFormField(
                            controller: controller.passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF5963DC),
                                ),
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                              ),
                            ),
                            obscureText: !controller.isPasswordVisible.value,
                            validator: (value) => value!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                          )),
                          const SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: controller.loginUser,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:const Color(0xFF5963DC),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Register Button
                          TextButton(
                            onPressed: () => Get.offNamed(Routes.REGISTER),
                            child: Text(
                              'Don\'t have an account? Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
