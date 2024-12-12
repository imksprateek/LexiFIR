import 'dart:convert';
import 'dart:io';
import 'package:app_client/pages/Chatbot.dart';
import 'package:app_client/services/functions/Transciption%20service.dart';
import 'package:app_client/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:siri_wave/siri_wave.dart';

AudioPlayer audioPlayer = AudioPlayer();

Future<void> textToSpeech(String text, Function(bool) updateWaveStatus) async {
  const String baseUrl = "http://server.ksprateek.studio";
  const String endpoint = "/api/speech/text-to-speech/";

  try {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'text': text};

    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 &&
        response.headers['content-type'] == 'application/octet-stream') {
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDir.path}/text_to_speech.mp3";

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          updateWaveStatus(true); // Show wave
        } else if (state == PlayerState.completed) {
          updateWaveStatus(false); // Hide wave
        } else if (state == PlayerState.stopped) {
          updateWaveStatus(false); // Hide wave
        }
      });

      await audioPlayer.play(DeviceFileSource(filePath));
    } else {
      print("Unexpected Content-Type: ${response.headers['content-type']}");
    }
  } catch (e) {
    print("Error during text-to-speech conversion: $e");
  }
}
