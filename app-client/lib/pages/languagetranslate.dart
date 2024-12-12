import 'package:flutter/material.dart';

var languages = ['Hindi', 'English'];
var originLanguage = "From";
var destinationLanguage = "To";
var output = "";

TextEditingController languageController = TextEditingController();

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translate"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              items: languages.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  originLanguage = value!;
                });
              },
              hint: Text(originLanguage),
              dropdownColor: Colors.white,

            
            ),
          ],
        ),
      ),
    );
  }
}
