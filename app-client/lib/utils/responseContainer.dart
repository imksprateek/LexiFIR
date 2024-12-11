import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';

class Responsecontainer extends StatelessWidget {
  final String IpcSection;
  final String Description;
  final String Confidence;
  Responsecontainer(
      {super.key,
      required this.IpcSection,
      required this.Description,
      required this.Confidence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Appbluelight2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Containerr()],
        ),
      ),
    );
  }

  Widget Containerr() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${IpcSection}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Confidence")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Description:${Description} "),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: (Colors.green)),
                      color: (const Color.fromARGB(255, 225, 255, 226)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${Confidence}%"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
