import 'package:app_client/pages/Chatbot.dart';
import 'package:app_client/pages/Lawmode.dart';
import 'package:app_client/pages/LegalAdvisory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/functions/Logout.dart';
import 'package:app_client/pages/fir_screen2.dart';
import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/carasouel.dart';
import 'package:app_client/utils/circle_container.dart';
import 'package:app_client/utils/colors.dart';

import 'dart:ui' as ui;

import '../services/functions/GlobalStartTranscirptionService.dart';
import 'Lawmode.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Fetch the username
    GetArticle();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ??
          'User'; // Default to 'User' if no username is found
    });
  }

  void ontap_fir() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const FillFirLawMode(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4f9ff),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight *
                  0.5, // Adjusting height relative to screen height
              child: Stack(
                children: [
                  Image.asset('lib/images/rect.png'),
                  Row(
                    children: [
                      SizedBox(width: screenWidth * 0.025), // Dynamic padding
                      IconButton(
                        onPressed: () {
                          logout(context);
                        },
                        icon: const Icon(Icons.translate, color: Colors.white),
                      ),
                      SizedBox(width: screenWidth * 0.55),
                      IconButton(
                        onPressed: () {
                          textToSpeech("Venkat pp small lmao , hahahahahaha");
                        },
                        icon: const Icon(
                          Icons.person_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top:
                        screenHeight * 0.08, // Adjusted for dynamic positioning
                    right: screenWidth * 0.4,
                    child: Text(
                      '''Welcome Back 
$username,''',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.6, // Adjusted for dynamic positioning
                    top: screenHeight * 0.07,
                    child: Container(
                      height: screenHeight * 0.2, // Adjust the height as needed
                      child: Image.asset('lib/images/cartoon.png', scale: 0.5),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.2, // Adjusted for dynamic positioning
                    left: screenWidth * 0.001,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "What do you want to do today?",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.3, // Adjusted for dynamic positioning
                    right: 2,
                    left: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: Container(
                        height:
                            screenHeight * 0.15, // Adjust the height as needed
                        width: screenWidth * 0.9, // Adjust the width as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset('lib/images/stats.png',
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    CircleContainer(
                      feature_name: "File FIR",
                      icon: Icons.file_copy,
                      ontap: ontap_fir,
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LegalAdvisory(),
                        ));
                      },
                      child: CircleContainer(
                        feature_name: "Legal Assistance",
                        icon: Icons.handshake,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoiceChat()));
                      },
                      child: CircleContainer(
                        feature_name: "Learn",
                        icon: Icons.book,
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircleContainer(
                      feature_name: "Saved Documents",
                      icon: Icons.save,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomCarousel(
              imageUrls: imageUrls,
              linkUrls: linkURLS,
              TitleUrls: titleUrls,
            ),
          ],
        ),
      ),
    );
  }
}
