import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
           height: 100,
            width: 100,
            color: Colors.red,
            child: Center(child: Text("zhavle bai"))),
      ),
    );
  }
}
