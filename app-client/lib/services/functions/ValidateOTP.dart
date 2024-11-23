import 'dart:convert';
import 'package:app_client/services/functions/Signin.dart';
import 'package:http/http.dart' as http;

Future<bool> validateOTP(String email, String otp ,String password ,List<String> role ,String name) async {
  // Define the base URL of your server
  String baseUrl = "http://server.ksprateek.studio";

  // Create the request URL
  String endpoint = "/api/auth/validateotp";

  // The payload (body of the request) will contain the email and OTP entered by the user
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'email': email,
    'otp': otp, // OTP entered by the user
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // OTP is valid
      print("OTP validated successfully.");
      signUp(name, email, password, role) ;

      return true;
    } else {
      // If the server returns an error
      print("Failed to validate OTP: ${response.body}");
      return false;
    }
  } catch (e) {
    // Handle any errors like network issues
    print("Error validating OTP: $e");
    return false;
  }
}
