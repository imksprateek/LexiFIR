import 'package:app_client/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:app_client/auth/LoginScreen.dart';

import 'auth/Loginui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken(); // Ensure this is called in initState
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token'); // Retrieve the token

    // Simulate a delay for the splash screen (optional)
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on token availability
    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    } else {
      // Token doesn't exist, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue, // Customize the background color
      body: Center(
        child: Text(
          'This is a Splash Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

