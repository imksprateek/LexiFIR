import 'package:app_client/pages/Lawmode.dart';
import 'package:app_client/pages/fir_screen2.dart';
import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';

class CaseDetailsScreen extends StatefulWidget {
  @override
  _CaseDetailsScreenState createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  // List to store the suspect sections
  List<Map<String, TextEditingController>> suspects = [];

  TextEditingController OfficerName = TextEditingController();
  TextEditingController OfficerDesignation = TextEditingController();

  TextEditingController ComplaintantName = TextEditingController();
  TextEditingController ComplaintantAge = TextEditingController();
  TextEditingController ComplaintantSex = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add an initial suspect section
    addSuspect();
  }

  void addSuspect() {
    setState(() {
      suspects.add({
        'name': TextEditingController(),
        'address': TextEditingController(),
      });
    });
  }

  void deleteLastSuspect() {
    if (suspects.isNotEmpty) {
      setState(() {
        suspects.removeLast();
      });
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers to avoid memory leaks
    for (var suspect in suspects) {
      suspect['name']?.dispose();
      suspect['address']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "LexiFIR",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ), // Removes the back button
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 1, 57, 109),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Save draft",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const DividerWithText(text: 'Suspect Details'),
              ...suspects.map((suspect) {
                return Column(
                  children: [
                    TextField(
                      controller: suspect['name'],
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: suspect['address'],
                      decoration: const InputDecoration(
                        hintText: 'Address of Suspect',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: deleteLastSuspect,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppBluelight,
                      ),
                      child: Center(
                        child: Text(
                          "Delete Last Suspect",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: addSuspect,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Appbluelight2,
                      ),
                      child: Center(
                        child: Text(
                          "Add Suspect",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const DividerWithText(text: 'Officer Details'),
              TextField(
                controller: OfficerName,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: OfficerDesignation,
                decoration: const InputDecoration(
                  hintText: 'Designation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const DividerWithText(text: 'Complainant Details'),
              TextField(
                controller: ComplaintantName,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ComplaintantAge,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: ComplaintantSex,
                      decoration: const InputDecoration(
                        hintText: 'Sex',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print(suspects);

                      for (var suspect in suspects) {
                        String name = suspect['name']?.text ?? '';
                        String address = suspect['address']?.text ?? '';
                        print('Suspect Name: $name, Suspect Address: $address');
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirAiScreen(Description: crimeDescriptionController.text,),
                        ),
                      );
                    },
                    child: const Text('Proceed'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
