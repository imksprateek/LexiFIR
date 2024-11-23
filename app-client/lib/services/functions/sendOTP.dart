import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> sendOTP(String email) async {
  // Define the base URL of your server
  String baseUrl = "http://server.ksprateek.studio";

  // Create the request URL
  String endpoint = "/api/auth/sendotp";

  // The payload (body of the request) will contain the user's email
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'email': email,
  };

  try {

    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {

      print("OTP sent successfully.");
      return true;
    } else {
      // If the server returns an error
      print("Failed to send OTP: ${response.body}");
      return false;
    }
  } catch (e) {

    print("Error sending OTP: $e");
    return false;
  }
}
