import 'package:app_client/services/functions/Logout.dart';
import 'package:app_client/pages/fir_screen.dart';
import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/carasouel.dart';
import 'package:app_client/utils/circle_container.dart';
import 'package:app_client/utils/colors.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app_client/auth/Loginui.dart';
import 'package:app_client/auth/LoginScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<Color> colours = [
  const Color.fromARGB(255, 255, 228, 190),
  const Color.fromARGB(255, 250, 219, 193),
  const Color.fromARGB(255, 255, 206, 175)
];
//List<String> titles = ["", "", ""];

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    // TODO: implement initState

    GetArticle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void ontap_fir() {
      print("FIR TAPPED!");

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const FirAiScreen(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
          IconButton(
            onPressed: () {
              // logout(context);
              textToSpeech("This is for efficient FIR filing , thank you" ) ;
            },
            icon: const Icon(
              Icons.person_outlined,
              size: 35,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,) ,
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Hello $username,",
              style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(98, 48, 2, 1),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              "What do you want to do today?",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.all(14),
            child: Container(
              height: 150,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: LightBrown,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
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
                  CircleContainer(
                    feature_name: "        Kedar seeing Icon now",
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomCarousel(
            imageUrls: imageUrls,
            linkUrls: linkURLS,
          )
        ],
      ),
    );
  }
}
