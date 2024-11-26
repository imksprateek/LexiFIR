import 'dart:convert';
import 'package:app_client/services/functions/sendOTP.dart';
import 'package:http/http.dart' as http;
bool resultFromSendotp = false;
Future<Map<String, dynamic>> checkUserExists(String username, String email ,String password ,  List<String> role) async {
  print('Checking if user exists...');

  String baseUrl = "http://server.ksprateek.studio"; // Replace with your base URL
  String endpoint = "/api/auth/checkuser"; // API endpoint

  // Set headers and request body
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'username': username,
    'email': email,
  };

  try {
    // Make the POST request
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Successful response
      resultFromSendotp = await sendOTP(email);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('CheckUser Response: $responseBody');

      return {
        'success': true,
        'message': responseBody['message'], // Extract server message
      };
    } else {
      // Failed response
      print('Failed to check user: ${response.body}');
      return {
        'success': false,
        'message': 'Failed to check user. Please try again.',
      };
    }
  } catch (e) {
    // Handle network or parsing errors
    print('Error while checking user: $e');
    return {
      'success': false,
      'message': 'An error occurred while checking user.',
    };
  }
}
