import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_client/services/functions/airequest.dart';

Future<dynamic> SevenWrequest(
    String prompt, String weapon, String category) async {
  const String baseUrl = "http://server.ksprateek.studio";
  const String endpoint = "/api/legal";

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {
    "what": prompt,
    "where": "",
    "when": "",
    "who": "",
    "how": prompt,
    "witness": "",
    "weapon": weapon,
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      // Extracting related sections
      List<dynamic> relatedSections = decodedResponse['relatedSections'] ?? [];
      List<dynamic> landmarkJudgments =
          decodedResponse['landmarkJudgments'] ?? [];

      // Format the output as a string
      StringBuffer result = StringBuffer();

      result.writeln("**Related Sections:**");
      for (var section in relatedSections) {
        result
            .writeln("- ${section['sectionCode']}: ${section['description']}");
        result.writeln("  **Relevance**: ${section['relevanceScore']}%");
        result.writeln("  Reasoning: ${section['reasoning']}");
        result.writeln();
      }

      result.writeln("**Landmark Judgments:**");
      for (var judgment in landmarkJudgments) {
        result.writeln("- ${judgment['title']}");
        result.writeln("  Summary: ${judgment['summary']}");
        result.writeln("  URL: ${judgment['url']}");
        result.writeln();
      }

      return result.toString();
    } else {
      logger.e("Request failed with status: ${response.statusCode}");
      logger.e("Response body: ${response.body}");
      return "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    logger.e("Error sending request: $e");
    return "Error sending request: $e";
  }
}
