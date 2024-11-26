import 'package:app_client/utils/colors.dart';
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
      body: Stack(
        children: [
          // Bottom input field and expanded space for content
          Column(
            children: [
              Expanded(
                child: Container(
                  // Placeholder for chat or other content
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: _ChatMessageController,
                    decoration: InputDecoration(
                      hintText: "Describe the crime that has happened",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Add functionality for the speaker icon here
                          print("Speaker icon tapped!");
                        },
                        icon: Icon(Icons.mic, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Center container
          Positioned(
            bottom: 360,
            left: 80,
            child: Center(
              child: Container(
                height: 200,
                width: 200,

                decoration: BoxDecoration(
                  color: LightBrown, // Replace with your desired color
                  borderRadius: BorderRadius.circular(20), // Rounds the edges
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // How wide the shadow spreads
                      blurRadius: 10, // The softness of the shadow
                      offset: Offset(4, 4), // Position of the shadow
                    ),
                  ],
                ), // You can replace this with any color
                child: Center(
                    child: Column(
                        children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        size: 100,
                        color: Colors.brown,
                      )) ,
                          Text("Click here to")
                ])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
