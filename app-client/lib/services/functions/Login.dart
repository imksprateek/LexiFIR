import 'dart:convert';
import 'package:app_client/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> login(String username, String password) async {
  print('Login function called');
  print('Username: $username');
  print('Password: $password');

  const String baseUrl = "http://server.ksprateek.studio"; // Replace with your base URL
  const String endpoint = "/api/auth/login"; // API endpoint for login

  // Set the headers and the request body
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'username': username, // Corrected key
    'password': password,
  };

  try {
    print('Making API request to: $baseUrl$endpoint');
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    print('API response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Login successful. Parsing response body...');

      // Parse the response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('Response body: $responseBody');

      // Extract necessary fields
      String token = responseBody['token'];
      String id = responseBody['id'];
      String email = responseBody['email'];
      List<String> roles = List<String>.from(responseBody['roles']);

      // Save the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      print('Token saved in SharedPreferences');

      // Return the extracted data
      return {
        'success': true,
        'token': token,
        'id': id,
        'email': email,
        'roles': roles,
      };
    } else {
      // Handle login failure
      print("Failed to login: ${response.body}");
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Invalid credentials',
      };
    }
  } catch (e) {
    // Handle any network or other errors
    print("Error during login: $e");
    return {
      'success': false,
      'message': 'An error occurred during login',
    };
  }
}
