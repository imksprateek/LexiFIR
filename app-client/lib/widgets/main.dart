import 'package:app_client/pages/Chatbot.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';
import 'package:app_client/services/functions/SttWebSocket.dart';
import 'package:app_client/utils/responseContainer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import '../SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('hi'), // Spanish
        ],
        locale: Locale('en'),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
