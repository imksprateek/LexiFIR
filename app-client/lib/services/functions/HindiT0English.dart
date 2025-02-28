import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> translateText(String text, String targetLanguage) async {
  final String url = 'http://34.226.190.77:5000/translate';

  if (text.isEmpty || targetLanguage.isEmpty) {
    throw Exception("Text and target language cannot be empty.");
  }

  try {
    Map<String, String> requestBody = {
      "text": text,
      "target_language": targetLanguage, // Ensure correct key names
    };

    print("Request payload: ${jsonEncode(requestBody)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"}, // Ensure correct header
      body: jsonEncode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
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
    throw Exception("Translation error: $e");
  }
}
