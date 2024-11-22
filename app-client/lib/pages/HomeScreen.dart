import 'package:app_client/utils/circle_container.dart';
import 'package:flutter/material.dart';

String username = "Venkat";

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.translate)),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_outlined,
              size: 35,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello $username,",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),
            Text(
              "What do you want to do today?",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircleContainer(
                    feature_name: "File FIR",
                    icon: (Icons.file_copy),
                  ),
                  SizedBox(width: 16),
                  CircleContainer(
                    feature_name: "Legal Assistance",
                    icon: Icons.handshake,
                  ),
                  SizedBox(width: 16),
                  CircleContainer(
                    feature_name: "Learn",
                    icon: Icons.book,
                  ),
                  SizedBox(width: 16),
                  CircleContainer(
                    feature_name: "Saved Documents",
                    icon: Icons.save,
                  ),
                  CircleContainer(
                    feature_name: "        Kedar seeing Icon now",
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
