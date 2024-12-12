import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

String? Ai_answer;
String? summarize;
String? summarizee;
final logger = Logger();

Future<dynamic> airequest(String prompt) async {
  const String baseUrl = "http://chat.ksprateek.studio";
  const String endpoint = "/chat";

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {"message": prompt};

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Request succeeded!");

      Ai_answer = response.body;
      logger.d(response.body);

      // Decode the response
      final decodedResponse = jsonDecode(response.body);
      print("Decoded response: $decodedResponse");

      // Ensure the decoded response is a Map
      if (decodedResponse is Map<String, dynamic>) {
        String? decodedAi = decodedResponse['response'];

        summarize = decodedResponse['summary'];

        // Log and return values
        summarizee = summarize?.split('Here is a summary:').last;

        if (summarize != null) {
          print("The summary of the above is: $summarize");
        } else {
          print("Summary key not found or null.");
        }

        return decodedAi;
      } else {
        print("Decoded response is not a valid JSON object.");
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  } catch (e) {
    print("Error sending request: $e");
  }
}
