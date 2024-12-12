import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> translateEnglishToHindi(String text) async {
  final String url = 'http://34.226.190.77:5000/translate';

  if (text.isEmpty) {
    throw Exception("Text to translate cannot be empty.");
  }

  try {
    // Prepare the request payload
    Map<String, String> requestBody = {
      "text": text,
      "target_language": "hi", // Target language set to Hindi
    };

    print("Request payload: ${jsonEncode(requestBody)}");

    // Send POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // Parse the response body
      final responseBody = jsonDecode(response.body);

      if (responseBody['translated_text'] != null) {
        return responseBody['translated_text'];
      } else {
        throw Exception("Response does not contain 'translated_text'.");
      }
    } else {
      throw Exception(
        "Translation failed. Status: ${response.statusCode}, Body: ${response.body}",
      );
    }
  } catch (e) {
    throw Exception("Error during translation: $e");
  }
}

