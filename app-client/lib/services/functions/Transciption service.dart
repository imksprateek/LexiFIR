import 'dart:async';
import 'dart:typed_data';
import 'package:app_client/utils/constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TranscriptionService1 {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  WebSocketChannel? _channel;
  StreamController<Uint8List>? _audioStreamController;
  bool _isRecording = false;

  final List<Uint8List> _audioChunks = [];
  final List<String> _transcriptions = [];
  final StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageController.stream;

  Timer? _silenceTimer;

  final double _silenceThreshold = 30.0; // Silence threshold in dB
  final Duration _silenceDuration = Duration(seconds: 2); // Silence duration to trigger stop

  Future<void> initialize() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission is required to record.");
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _initializeWebSocket(String url) async {
    await _closeWebSocket();
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
            (message) {
          _messageController.add(message);
          _transcriptions.add(message);
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

      _audioStreamController!.stream.listen(
            (audioChunk) {
          if (_channel != null && _channel!.closeCode == null) {
            _channel!.sink.add(audioChunk);
          }
          _audioChunks.add(audioChunk);
        },
        onError: (error) {
          print("Error sending audio chunk: $error");
        },
        onDone: () {
          print("Audio stream closed.");
        },
      );

      // Start monitoring audio levels for pauses
      _monitorSilence();
    } catch (e) {
      print("Error starting recorder: $e");
      _isRecording = false;
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _isRecording = false;

    try {
      _silenceTimer?.cancel();
      await _recorder.stopRecorder();
      if (_channel != null && _channel!.closeCode == null) {
        _channel!.sink.add("submit_response");
      }

      print(_transcriptions.join(' '));
      conversation = _transcriptions.join(' ') ;
    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }

  void _monitorSilence() {
    _recorder.onProgress!.listen((event) {
      final audioLevel = event.decibels ?? -120.0; // Default to low value if null

      // Log audio levels for debugging
      print("Audio Level: $audioLevel");

      if (audioLevel < _silenceThreshold) {
        // Silence detected, start or reset the timer
        if (_silenceTimer == null || !_silenceTimer!.isActive) {
          print("Audio level below 20 dB. Starting silence timer...");
          _silenceTimer = Timer(_silenceDuration, () {
            print("Prolonged low audio level detected for 3 seconds. Stopping recording...");
            stopRecording(); // Ensure recording stops
          });
        }
      } else {
        // Audio detected, cancel the silence timer
        if (_silenceTimer != null && _silenceTimer!.isActive) {
          print("Audio level above 20 dB. Resetting silence timer...");
          _silenceTimer?.cancel();
        }
      }
    });
  }

  Future<void> dispose() async {
    _silenceTimer?.cancel();
    _audioStreamController?.close();
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    await _recorder.closeRecorder();
    await _closeWebSocket();
    await _messageController.close();
  }
}
class TranscriptionServiceBot{
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  WebSocketChannel? _channel;
  StreamController<Uint8List>? _audioStreamController;
  bool _isRecording = false;

  final List<Uint8List> _audioChunks = [];
  final List<String> _transcriptions = [];
  final StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageController.stream;

  Timer? _silenceTimer;

  final double _silenceThreshold = 25.0; // Silence threshold in dB
  final Duration _silenceDuration = Duration(seconds: 3); // Silence duration to trigger stop

  Future<void> initialize() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission is required to record.");
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _initializeWebSocket(String url) async {
    await _closeWebSocket();
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
            (message) {
          _messageController.add(message);
          _transcriptions.add(message);
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

      _audioStreamController!.stream.listen(
            (audioChunk) {
          if (_channel != null && _channel!.closeCode == null) {
            _channel!.sink.add(audioChunk);
          }
          _audioChunks.add(audioChunk);
        },
        onError: (error) {
          print("Error sending audio chunk: $error");
        },
        onDone: () {
          print("Audio stream closed.");
        },
      );

      // Start monitoring audio levels for pauses
      _monitorSilence();
    } catch (e) {
      print("Error starting recorder: $e");
      _isRecording = false;
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    _isRecording = false;

    try {
      _silenceTimer?.cancel();
      await _recorder.stopRecorder();
      if (_channel != null && _channel!.closeCode == null) {
        _channel!.sink.add("submit_response");
      }

      print(_transcriptions.join(' '));
      ForBot = _transcriptions.join(' ') ;
    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }

  void _monitorSilence() {
    _recorder.onProgress!.listen((event) {
      final audioLevel = event.decibels ?? -120.0; // Default to low value if null

      // Log audio levels for debugging
      print("Audio Level: $audioLevel");

      if (audioLevel < _silenceThreshold) {
        // Silence detected, start or reset the timer
        if (_silenceTimer == null || !_silenceTimer!.isActive) {
          print("Audio level below 20 dB. Starting silence timer...");
          _silenceTimer = Timer(_silenceDuration, () {
            print("Prolonged low audio level detected for 3 seconds. Stopping recording...");
            stopRecording(); // Ensure recording stops
          });
        }
      } else {
        // Audio detected, cancel the silence timer
        if (_silenceTimer != null && _silenceTimer!.isActive) {
          print("Audio level above 20 dB. Resetting silence timer...");
          _silenceTimer?.cancel();
        }
      }
    });
  }

  Future<void> dispose() async {
    _silenceTimer?.cancel();
    _audioStreamController?.close();
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    await _recorder.closeRecorder();
    await _closeWebSocket();
    await _messageController.close();
  }
}