import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> textToSpeech(String text) async {
  const String baseUrl = "http://server.ksprateek.studio"; // Replace with your base URL
  const String endpoint = "/api/speech/text-to-speech/";

  try {
    // Create the request body
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      'text': text,
    };

    // Send POST request
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    print("Response status: ${response.statusCode}");
    print("Content-Type: ${response.headers['content-type']}");

    if (response.statusCode == 200) {
      if (response.headers['content-type'] == 'application/octet-stream') {
        // Save the binary MP3 data to a file
        Directory appDir = await getApplicationDocumentsDirectory();
        String filePath = "${appDir.path}/text_to_speech.mp3";

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("MP3 file saved at: $filePath");

        // Play the audio using audioplayers
        AudioPlayer audioPlayer = AudioPlayer();

        // Play the file using DeviceFileSource (no need for isLocal)
       await audioPlayer.play(DeviceFileSource(filePath));


      } else {
        print("Unexpected Content-Type: ${response.headers['content-type']}");
      }
    } else {
      print("Failed to convert text to speech. Response: ${response.body}");
    }
  } catch (e) {
    print("Error during text-to-speech conversion: $e");
  }
}
