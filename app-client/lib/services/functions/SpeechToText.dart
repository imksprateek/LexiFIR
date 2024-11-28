import 'dart:io';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:path_provider/path_provider.dart'; // For temporary directory access
import 'package:http/http.dart' as http;

Future<void> SpeechToText(String assetPath) async {
  const String baseUrl = "http://server.ksprateek.studio";
  const String endpoint = "/api/speech/speech-to-text";

  try {
    // Load the asset file
    final byteData = await rootBundle.load(assetPath);

    // Save the asset file to a local file
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/Recording.m4a';
    File tempFile = File(tempPath);
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    print("File copied to: $tempPath");

    // Prepare the API request
    var uri = Uri.parse(baseUrl + endpoint);
    var request = http.MultipartRequest('POST', uri);

    // Attach the file
    request.files.add(await http.MultipartFile.fromPath('file', tempFile.path));

    // Send the request
    var response = await request.send();

    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print("Speech-to-Text Result: $responseBody");
    } else {
      print("Failed to process speech. Status Code: ${response.statusCode}");
      var errorBody = await response.stream.bytesToString();
      print("Error Details: $errorBody");
    }
  } catch (e) {
    print("Error during speech-to-text conversion: $e");
  }
}
