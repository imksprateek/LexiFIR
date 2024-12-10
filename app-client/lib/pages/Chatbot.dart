import 'package:app_client/services/functions/airequest.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/constants.dart';
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

      await _transcriptionService.startRecording(serverUrl); // Replace serverUrl with your WebSocket URL
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
            stopVoiceChat() ;
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
      print("Recording stopped.");
      print("Final conversation: $_conversation");
      String airesponse = await airequest(_conversation) ;
      // Automatically trigger Text-to-Speech after recording stops
      if (_conversation.isNotEmpty) {
        if (!_isSpeaking) {
          _isSpeaking = true; // Set flag before speaking
          await textToSpeech(airesponse); // Call the Text-to-Speech function
          _isSpeaking = false; // Reset flag after speaking
        }

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
      appBar: AppBar(title: const Text("Voice Chat")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startVoiceChat,
              child: const Text("Start Recording"),
            ),
            ElevatedButton(
              onPressed: stopVoiceChat,
              child: const Text("Stop Recording"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Conversation: $_conversation",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
