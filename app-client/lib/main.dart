import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';

import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
