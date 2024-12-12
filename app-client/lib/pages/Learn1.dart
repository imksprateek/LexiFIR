import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hyperlink/hyperlink.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/carasouel.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}
class _LearningScreenState extends State<LearningScreen> {
  final List<String> iurl = [
    "https://img.youtube.com/vi/dVPedKxq7Sw/0.jpg",
    "https://img.youtube.com/vi/OZMnJagCjxk/0.jpg",
    "https://img.youtube.com/vi/orFEKfz6Lxw/0.jpg"

  ];
  final List<String> lurl = [
    "https://www.youtube.com/watch?v=dVPedKxq7Sw",
    "https://www.youtube.com/watch?v=OZMnJagCjxk",
    "https://www.youtube.com/watch?v=orFEKfz6Lxw&list=PLCszFOPmwm7R0OU1AxYomJgK_2WkRfoC3"
  ];
  final List<String> turl = [
    "Video Title 1: Understanding Safety",
    "Video Title 2: Personal Security Tips",
    "Video Title 2: Brief Introduction of IPC"
  ];
  final List<String> categories = [
    'Assault',
    'Rape',
    'Harassment',
    'Accident',
    'Dacoity',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ),
          // Pass the corrected lists to the carousel
          CustomCarousel(imageUrls: iurl, linkUrls: lurl, TitleUrls: turl),
          const SizedBox(height: 20),
          const Text("Browse By Category", textAlign: TextAlign.left),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryContainer(categories[index]);
              },
            ),
          ),
          const Text("Resume"),
          Container(
            height: 200,
            width: 360,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _buildCategoryContainer(String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
