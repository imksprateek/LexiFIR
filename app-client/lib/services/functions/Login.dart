import 'dart:convert';
import 'package:app_client/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> login(String _username, String password) async {
  print('Login function called');
  print('Username: $_username');
  print('Password: $password');

  String baseUrl =
      "http://server.ksprateek.studio"; // Replace with your base URL
  String endpoint = "/api/auth/login"; // API endpoint for login

  // Set the headers and the request body
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'username': _username,
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

      LoginSuccessfull = true;

      username = _username;
      // Successfully logged in, parse the response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('Response body: $responseBody');

      String token = responseBody['token']; // Extract the token
      String id = responseBody['id']; // Extract user id
      String email = responseBody['email']; // Extract email
      List<String> roles =
          List<String>.from(responseBody['roles']); // Extract roles

      // Save the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token); // Save token
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
      // If the login fails, return an error message
      print("Failed to login: ${response.body}");
      return {
        'success': false,
        'message': 'Invalid credentials or error during login',
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
