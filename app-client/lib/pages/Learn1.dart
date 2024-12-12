import 'package:flutter/material.dart';
import 'package:app_client/utils/carasouel.dart'; // Ensure this import is correct

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  // List of categories to display in the grid
  final List<String> categories = [
    'Assault',
    'Rape',
    'Harassment',
    'Accident',
    'Dacoity'
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ),

          Container(
            height: 200,
            width: 360,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          // Uncomment and configure CustomCarousel as needed
          // CustomCarousel(
          //   imageUrls: [],
          //   linkUrls: [],
          //   titleUrls: [],
          // ),

          Text(
            "Browse By Category",
            textAlign: TextAlign.left,
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

          Text("Resume"),
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
