import 'package:flutter/material.dart';
import 'package:dellight/features/chatbot/presentation/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              const CircleAvatar(
                radius: 120, // Increased from 80
                backgroundImage: AssetImage(
                  'assets/images/icon_logo.png',
                ), // Replace with your logo
              ),
              const SizedBox(height: 48), // Increased from 32
              // Welcome Text
              const Text(
                'Welcome to Dellight',
                style: TextStyle(
                  fontSize: 32, // Increased from 24
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12), // Increased from 8
              const Text(
                'Slogan',
                style: TextStyle(
                  fontSize: 24, // Increased from 18
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48), // Increased from 32
              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 20), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 24), // Increased from 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
