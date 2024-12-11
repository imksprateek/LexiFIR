import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> legalrequest(String Prompt) async {
  const String baseUrl = "http://chat.ksprateek.studio";
  const String endpoint = "/chat";

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {
    "message": Prompt,
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );
  } catch (e) {
    print(e);
  }
}
