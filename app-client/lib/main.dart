import 'package:app_client/pages/Chatbot.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';
import 'package:app_client/utils/responseContainer.dart';

import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
=======
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
>>>>>>> be82ad8cd62bf692f28143d30a1e5117f9d35249
  }
}
