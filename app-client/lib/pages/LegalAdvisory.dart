import 'package:app_client/services/functions/Chatmessage.dart';
import 'package:app_client/services/functions/airequest.dart';
import 'package:flutter/material.dart';

class LegalAdvisory extends StatefulWidget {
  const LegalAdvisory({super.key});

  @override
  State<LegalAdvisory> createState() => _LegalAdvisoryState();
}

class _LegalAdvisoryState extends State<LegalAdvisory> {
  List<ChatMessage> _messages = [];
  TextEditingController _legaladvisoryController = TextEditingController();

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(content: message, isUser: true));
      _legaladvisoryController.clear();
    });
  }

  void _addAIMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(content: message, isUser: false));
    });
  }

  Future<void> ai_answer() async {
    String userMessage = _legaladvisoryController.text;
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
          'Legal Advisory',
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
                        // style: const TextStyle(fontSize: 16),
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
                controller: _legaladvisoryController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attachment),
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
                            if (_legaladvisoryController.text
                                .trim()
                                .isNotEmpty) {
                              ai_answer();
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.mic))
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
