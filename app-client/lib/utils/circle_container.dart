import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  IconData icon;
  String feature_name;
  CircleContainer({super.key, required this.feature_name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80, // Specify the width
          height: 80, // Specify the height
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 255, 228, 194),

            // Optional: Add a color to visualize the circle
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 80, 27, 8),
          ),
        ),
        Text(feature_name)
      ],
    );
  }
}
