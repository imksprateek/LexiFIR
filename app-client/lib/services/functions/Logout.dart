import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/LoginUInew.dart';


Future<void> logout(BuildContext context) async {
  try {
    print('Logout function called');

    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the token
    bool isRemoved = await prefs.remove('jwt_token');
    if (isRemoved) {
      print('Token removed successfully');

      // Navigate to the LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    } else {
      print('Failed to remove token');
    }
  } catch (e) {
    // Handle errors
    print('Error during logout: $e');
  }
}
