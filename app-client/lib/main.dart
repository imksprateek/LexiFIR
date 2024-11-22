import 'package:app_client/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'SplashScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homescreen());
  }
}
