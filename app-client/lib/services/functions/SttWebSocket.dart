import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TranscriptionPage extends StatefulWidget {
  const TranscriptionPage({Key? key}) : super(key: key);

  @override
  State<TranscriptionPage> createState() => _TranscriptionPageState();
}

class _TranscriptionPageState extends State<TranscriptionPage> {
  List<String> msg_recv = [];
  WebSocketChannel? _channel;
  bool _isRecording = false;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamController<Uint8List>? _audioStreamController;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeWebSocket() async {
    // Close any previous WebSocket connection
    _channel?.sink.close();

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse("ws://eng.ksprateek.studio/TranscribeStreaming"),
      );

      _channel!.stream.listen(
            (message) {
          print("Message from server: $message");
          setState(() {
            msg_recv.add(message);
          });
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

  Future<void> _initializeRecorder() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showErrorDialog("Microphone permission is required to record.");
      return;
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    // Reinitialize WebSocket and StreamController
    await _initializeWebSocket();

    _audioStreamController?.close();
    _audioStreamController = StreamController<Uint8List>();

    setState(() {
      _isRecording = true;
    });

    try {
      await _recorder.startRecorder(
        toStream: _audioStreamController!.sink,
        codec: Codec.pcm16,
        sampleRate: 16000,
        numChannels: 1,
        bufferSize: 1024,
      );

      // Send audio chunks to WebSocket
      _audioStreamController!.stream.listen((audioChunk) {
        if (_channel != null && _channel!.closeCode == null) {
          _channel!.sink.add(audioChunk);
        }
      });
    } catch (e) {
      print("Error starting recorder: $e");
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    setState(() {
      _isRecording = false;
    });

    try {
      await _recorder.stopRecorder();
      _channel?.sink.add("submit_response"); // Notify server that recording is complete
    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioStreamController?.close();
    if (_recorder.isRecording) {
      _recorder.stopRecorder();
    }
    _recorder.closeRecorder();
    _channel?.sink.close();
    msg_recv.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Real-Time Transcription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording();
                } else {
                  await _startRecording();
                }
              },
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            const SizedBox(height: 16),
            const Text("Transcriptions will appear here."),
            Expanded(
              child: msg_recv.isEmpty
                  ? const Center(child: Text("No messages received yet."))
                  : ListView.builder(
                itemCount: msg_recv.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(msg_recv[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
