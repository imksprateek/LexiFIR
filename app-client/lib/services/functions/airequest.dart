import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

String? Ai_answer;
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
      print("Request succeededdd lets fkn go !");

      Ai_answer = response.body;
      logger.d(response.body);

      final decodedResponse = jsonDecode(response.body);
      print("Decoded response: $decodedResponse");

      String decodedAi = decodedResponse['response'];

      return decodedAi;
    } else {
      print("Request failed with status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  } catch (e) {
    print("Error sending request: $e");
  }
}
