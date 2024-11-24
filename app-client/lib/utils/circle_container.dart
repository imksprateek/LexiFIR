import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  IconData icon;
  String feature_name;
  final VoidCallback? ontap;

  CircleContainer(
      {super.key, required this.feature_name, required this.icon, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ontap,
          child: Container(
            width: 60, // Specify the width
            height: 60, // Specify the height
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 255, 228, 194),

              // Optional: Add a color to visualize the circle
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 80, 27, 8),
            ),
          ),
        ),
        Text(feature_name)
      ],
    );
  }
}
