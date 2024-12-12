import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

Future<String?> ownmodel(String prompt) async {
  const String baseUrl = "http://34.228.65.175:5000";
  const String endpoint = "/predict";

  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final Map<String, dynamic> body = {"description": prompt};

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      logger.d("Request succeeded with status: ${response.statusCode}");

      // Decode the JSON response
      final decodedResponse = jsonDecode(response.body);

      // Validate the response format
      if (decodedResponse is Map<String, dynamic>) {
        final mainPrediction = decodedResponse['main_prediction'];
        final topPredictions =
            decodedResponse['top_predictions'] as List<dynamic>?;

        // Format the final response string
        String finalResponse = "----------------------------\n";
        finalResponse += " **Main Prediction** \n";
        finalResponse += "----------------------------\n";

        if (mainPrediction != null) {
          finalResponse += " **Offense**: ${mainPrediction['Offense']}\n";
          finalResponse += " **Punishment**: ${mainPrediction['Punishment']}\n";
          finalResponse += " **Scenario**: ${mainPrediction['Scenario']}\n";
          finalResponse += " **Section**: ${mainPrediction['Section']}\n";
        }

        if (topPredictions != null) {
          finalResponse += "\n----------------------------\n";
          finalResponse += " **Top Predictions** \n";
          finalResponse += "----------------------------\n";
          for (var prediction in topPredictions) {
            finalResponse += "\n **Offense**: ${prediction['Offense']}\n";
            finalResponse +=
                " **Confidence Score**: ${prediction['Confidence Score']}%\n";
            finalResponse += " **Punishment**: ${prediction['Punishment']}\n";
            finalResponse += " **Scenario**: ${prediction['Scenario']}\n";
            finalResponse += " **Section**: ${prediction['Section']}\n";
            finalResponse += "----------------------------\n";
          }
        }

        // Return the final formatted response string
        return finalResponse;
      } else {
        logger.w("Invalid JSON format in the response body.");
        return null;
      }
    } else {
      logger.e("Request failed with status: ${response.statusCode}");
      logger.e("Response body: ${response.body}");
      return null;
    }
  } catch (e) {
    logger.e("Error sending request: $e");
    return null;
  }
}
