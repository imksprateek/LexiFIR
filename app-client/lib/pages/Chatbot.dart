import 'package:app_client/services/functions/airequest.dart';
import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/constants.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import '../services/functions/Transciption service.dart';

class VoiceChat extends StatefulWidget {
  const VoiceChat({super.key});

  @override
  State<VoiceChat> createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat> {
  final TranscriptionService _transcriptionService = TranscriptionService();
  String _conversation = ""; // Store the final conversation
  StreamSubscription<String>? _transcriptionSubscription;
  bool _isSpeaking = false; // Track if text-to-speech is in progress
  final controller = IOS7SiriWaveformController(
    amplitude: 0.5,
    color: AppBluelight,
    frequency: 4,
    speed: 0.15,
  );
  @override
  void initState() {
    super.initState();
    initializeService();
  }

  // Initialize the transcription service
  Future<void> initializeService() async {
    try {
      await _transcriptionService.initialize();
      print("Transcription service initialized.");
    } catch (e) {
      print("Error initializing transcription service: $e");
    }
  }

  // Start recording and handle transcription
  void startVoiceChat() async {
    try {
      setState(() {
        _conversation = ""; // Clear previous conversation
      });

      await _transcriptionService.startRecording(
          serverUrl); // Replace serverUrl with your WebSocket URL
      print("Recording started.");

      // Cancel any existing subscription
      _transcriptionSubscription?.cancel();

      // Listen to real-time transcriptions
      _transcriptionSubscription =
          _transcriptionService.messages.distinct().listen((transcription) {
        print("Received transcription: $transcription"); // Debugging
        if (!transcription.toLowerCase().startsWith("final transcript:")) {
          setState(() {
            _conversation += "$transcription "; // Append transcription
          });
        }
        stopVoiceChat();
      }, onError: (error) {
        print("Error in transcription stream: $error");
      }, onDone: () {
        print("Transcription stream closed.");
        // Automatically stop when the stream closes
      });
    } catch (e) {
      print("Error starting voice chat: $e");
    }
  }

  // Stop recording and process final transcription
  void stopVoiceChat() async {
    try {
      await _transcriptionService.stopRecording();
      String airesponse = await airequest(_conversation);

      if (_conversation.isNotEmpty && !_isSpeaking) {
        _isSpeaking = true;
        await textToSpeech(airesponse, (status) {
          setState(() {
            showWave = status;
          });
        });
        _isSpeaking = false;
      }
    } catch (e) {
      print("Error stopping voice chat: $e");
    }
  }


  // Dispose resources
  @override
  void dispose() {
    _transcriptionSubscription?.cancel(); // Cancel subscription
    _transcriptionService.dispose(); // Dispose transcription service
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            // Reserve space for the waveform widget
            SizedBox(
              height: 200, // Fixed height for the reserved space
              child: showWave
                  ? SiriWaveform.ios7(
                controller: controller,
                options: const IOS7SiriWaveformOptions(height: 200, width: 400),
              )
                  : null, // If not showing, leave space empty
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _conversation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 300,
            ),
            ElevatedButton(
              onPressed: startVoiceChat,
              child: const Text("x Recording"),
            ),
          ],
        ),
      ),
    );
  }}
