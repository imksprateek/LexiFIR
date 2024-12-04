import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/functions/Logout.dart';
import 'package:app_client/pages/fir_screen.dart';
import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/carasouel.dart';
import 'package:app_client/utils/circle_container.dart';
import 'package:app_client/utils/colors.dart';

import 'dart:ui' as ui;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? username; // Variable to store the retrieved username

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
      builder: (context) => const FirAiScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4f9ff),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Image.asset('lib/images/rect.png'),
              Row(

                children:  [
                  SizedBox(width: 10,),
                  IconButton(
                    onPressed: () {
                      logout(context);
                    },
                    icon: const Icon(Icons.translate ,color: Colors.white,),
                  ),
                  SizedBox(width: 250,),
                  IconButton(
                    onPressed: () {
                      textToSpeech("Venkat pp small  lmao , hahahahahaha");
                    },
                    icon: const Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],),
              Positioned(
                top: 60,
                right: 140,
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
                left: 240,
                top: 60,
                child: Container(
                  height: 110,
                    child: Image.asset('lib/images/cartoon.png' ,scale: 0.5,)),
              ) ,

              Positioned(
                top: 150,
                left: 5,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "What do you want to do today?",
                    style: TextStyle(fontSize: 14 ,color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
      
            ]),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8),
              child: Container(
                height: 120,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // Shadow color
                      spreadRadius: 3, // How much the shadow spreads
                      blurRadius: 6, // How blurry the shadow is
                      offset: Offset(0, 3), // Position of the shadow (horizontal, vertical)
                    ),
                  ],
                ),
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
                      icon: (Icons.file_copy),
                      ontap: ontap_fir,
                    ),
                    const SizedBox(width: 16),
                    CircleContainer(
                      feature_name: "Legal Assistance",
                      icon: Icons.handshake,
                    ),
                    const SizedBox(width: 16),
                    CircleContainer(
                      feature_name: "Learn",
                      icon: Icons.book,
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
            )
          ],
        ),
      ),
    );
  }
}

//Add this CustomPaint widget to the Widget Tree
