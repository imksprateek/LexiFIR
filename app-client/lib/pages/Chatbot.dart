import 'package:flutter/material.dart';
class VoiceChat extends StatefulWidget {
  const VoiceChat({super.key});

  @override
  State<VoiceChat> createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: ElevatedButton(onPressed: (){}, child: Text("Start")),
      ),
    );
  }
}
