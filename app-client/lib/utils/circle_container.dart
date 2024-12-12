import 'package:flutter/material.dart';

import 'colors.dart';

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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFcee8ff),

              // Optional: Add a color to visualize the circle
            ),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          feature_name,
        )
      ],
    );
  }
}
