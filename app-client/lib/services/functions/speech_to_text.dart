import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextt extends StatefulWidget {
  const SpeechToTextt({super.key});

  @override
  State<SpeechToTextt> createState() => _SpeechToTexttState();
}

class _SpeechToTexttState extends State<SpeechToTextt> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Listening..."),
      
    );
  }
}
