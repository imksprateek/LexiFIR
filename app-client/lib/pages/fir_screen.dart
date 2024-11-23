import 'package:flutter/material.dart';

final TextEditingController _ChatMessageController = TextEditingController();

class FirAiScreen extends StatefulWidget {
  const FirAiScreen({super.key});

  @override
  State<FirAiScreen> createState() => _FirAiScreenState();
}

class _FirAiScreenState extends State<FirAiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const Drawer(
        child: Column(
          children: [Text("Chat History")],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      controller: _ChatMessageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
