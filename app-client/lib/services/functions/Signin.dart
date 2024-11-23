import 'dart:convert';
import 'package:app_client/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> signUp(String username, String email, String password, List<String> roles) async {
  // Define the base URL of your server
  String baseUrl = "http://server.ksprateek.studio";

  // Create the request URL for sign-up
  String endpoint = "/api/auth/signup"; // Change this to the correct endpoint

  // Headers for the request
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // The payload (body) for the request will contain the username, email, roles, and password
  Map<String, dynamic> body = {
    'username': username,
    'email': email,
    'roles': roles,
    'password': password,
  };

  try {
    // Make the POST request to the server
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Handle success
      print("User registered successfully!");
      SigninSuccessfull = true ;
      return true;
    } else {
      // Handle error if the server returns a non-200 status code
      print("Failed to sign up: ${response.body}");
      return false;
    }
  } catch (e) {
    // Catch any errors (e.g., network errors)
    print("Error during sign-up: $e");
    return false;
  }
}
