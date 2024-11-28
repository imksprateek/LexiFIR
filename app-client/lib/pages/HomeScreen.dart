import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:app_client/services/functions/Logout.dart';
import 'package:app_client/pages/fir_screen.dart';
import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/services/functions/TexttoSpeech.dart';
import 'package:app_client/utils/carasouel.dart';
import 'package:app_client/utils/circle_container.dart';
import 'package:app_client/utils/colors.dart';

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
      username = prefs.getString('username') ?? 'User'; // Default to 'User' if no username is found
    });
  }

  void ontap_fir() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const FirAiScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.translate),
          ),
          IconButton(
            onPressed: () {
              textToSpeech("Venkat pp small  lmao , hahahahahaha");
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Hello $username,",
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(98, 48, 2, 1),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "What do you want to do today?",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(14),
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
