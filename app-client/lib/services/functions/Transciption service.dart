import 'dart:async';
import 'dart:typed_data';
import 'package:app_client/utils/constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TranscriptionService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  WebSocketChannel? _channel;
  StreamController<Uint8List>? _audioStreamController;
  bool _isRecording = false;

  // Store all the audio chunks for the entire conversation
  final List<Uint8List> _audioChunks = [];

  // Store all the transcribed text messages
  final List<String> _transcriptions = [];

  // Listener for incoming messages from the WebSocket
  final StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageController.stream;

  Future<void> initialize() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission is required to record.");
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _initializeWebSocket(String url) async {
    // Close any previous WebSocket connection
    await _closeWebSocket();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
            (message) {
          _messageController.add(message);
          _transcriptions.add(message);  // Store transcribed message here
        },
        onError: (error) {
          print("WebSocket Error: $error");
        },
        onDone: () {
          print("WebSocket connection closed.");
        },
      );
    } catch (e) {
      print("Error initializing WebSocket: $e");
    }
  }

  Future<void> _closeWebSocket() async {
    if (_channel != null) {
      try {
        await _channel!.sink.close();
      } catch (e) {
        print("Error closing WebSocket: $e");
      }
      _channel = null;
    }
  }

  Future<void> startRecording(String webSocketUrl) async {
    if (_isRecording) return;

    // Reinitialize WebSocket and StreamController
    conversation = "";  // Reset the conversation string
    _transcriptions.clear();
    await _initializeWebSocket(webSocketUrl);

    _audioStreamController?.close();
    _audioStreamController = StreamController<Uint8List>();

    _isRecording = true;

    try {
      await _recorder.startRecorder(
        toStream: _audioStreamController!.sink,
        codec: Codec.pcm16,
        sampleRate: 16000,
        numChannels: 1,
        bufferSize: 1024,
      );

      // Send audio chunks to WebSocket and store them in the list
      _audioStreamController!.stream.listen(
            (audioChunk) {
          if (_channel != null && _channel!.closeCode == null) {
            _channel!.sink.add(audioChunk);
          }
          // Accumulate the audio chunks in the list
          _audioChunks.add(audioChunk);
        },
        onError: (error) {
          print("Error sending audio chunk: $error");
        },
        onDone: () {
          print("Audio stream closed.");
        },
      );
    } catch (e) {
      print("Error starting recorder: $e");
      _isRecording = false;
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _isRecording = false;

    try {
      await _recorder.stopRecorder();
      if (_channel != null && _channel!.closeCode == null) {
        _channel!.sink.add("submit_response"); // Notify server that recording is complete
      }

      // Print the transcriptions as a single string without commas or brackets
      print(_transcriptions.join(' '));
      conversation   = _transcriptions.join(' ') ;
      print(conversation) ;// Join transcriptions with a space
      // You can replace ' ' with '\n' if you prefer each transcription to be on a new line

    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }


  // Get the entire list of transcriptions
  List<String> get transcriptions => _transcriptions;

  Future<void> dispose() async {
    _audioStreamController?.close();
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    await _recorder.closeRecorder();
    await _closeWebSocket();
    await _messageController.close();
  }
}
