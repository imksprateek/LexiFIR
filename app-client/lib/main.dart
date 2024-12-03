//import 'package:app_client/auth/LoginScreen.dart';
import 'package:app_client/auth/LoginUInew.dart';
import 'package:app_client/auth/Loginui.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}
