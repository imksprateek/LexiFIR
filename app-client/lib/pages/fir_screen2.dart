import 'dart:ffi';

import 'package:app_client/services/functions/Chatmessage.dart';

import 'package:app_client/services/functions/airequest.dart';
import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';

final TextEditingController _ChatMessageController = TextEditingController();

class FirAiScreen extends StatefulWidget {
  final String Description;
  FirAiScreen({super.key, required this.Description});

  @override
  State<FirAiScreen> createState() => _FirAiScreenState();
}

class _FirAiScreenState extends State<FirAiScreen> {
  @override
  void initState() {
    // TODO: implement initState

    initai();

    super.initState();
  }

  final List<ChatMessage> _messages = []; // To store chat messages

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(content: message, isUser: true));
      _ChatMessageController.clear();
    });

    //Simulate AI response
  }

  void _addAIMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(content: message, isUser: false));
    });
  }

  Future<void> initai() async {
    String userMessage = widget.Description.toString();
    if (userMessage.trim().isEmpty) return;

    _addUserMessage(userMessage);

    String? aiResponse = await airequest(userMessage);

    if (aiResponse != null) {
      _addAIMessage(aiResponse);
    } else {
      _addAIMessage("AI could not process the request.");
    }
  }

  Future<void> ai_answer() async {
    String userMessage = _ChatMessageController.text;
    if (userMessage.trim().isEmpty) return;

    _addUserMessage(userMessage);

    String? aiResponse = await airequest(userMessage);

    if (aiResponse != null) {
      _addAIMessage(aiResponse);
    } else {
      _addAIMessage("AI could not process the request.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Fir AI Chat',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: //Text(
                        //message.content,
                        //style: const TextStyle(fontSize: 16),
                        //),

                        RichText(text: parseTextWithBold(message.content)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: _ChatMessageController,
                decoration: InputDecoration(
                  hintText: "Type your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: SizedBox(
                    width: 96,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            //airequest(_ChatMessageController.text);
                            if (_ChatMessageController.text.trim().isNotEmpty) {
                              ai_answer();

                              
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                        IconButton(onPressed: () {

                        


                        }, icon: Icon(Icons.mic))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan parseTextWithBold(String input) {
    List<TextSpan> spans = [];
    final regex = RegExp(r"(\*\*.*?\*\*|\*.*?\*)");

    int lastIndex = 0;
    for (final match in regex.allMatches(input)) {
      // Add regular text before the match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: input.substring(lastIndex, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }

      // Add bold or italic text
      final matchedText = match.group(0)!;
      spans.add(TextSpan(
        text: matchedText.replaceAll('*', ''), // Remove markers
        style: matchedText.startsWith('**')
            ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
            : const TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
      ));

      lastIndex = match.end;
    }

    // Add remaining regular text after the last match
    if (lastIndex < input.length) {
      spans.add(TextSpan(
        text: input.substring(lastIndex),
        style: const TextStyle(color: Colors.black),
      ));
    }

    return TextSpan(children: spans);
  }
}


          /* Positioned(
            bottom: 360,
            left: 80,
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Appbluelight2,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          print("Attach documents button clicked");
                        },
                        icon: const Icon(
                          Icons.attach_file,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '''Click here to Attach      
Documents or Start Typing''',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),*/
