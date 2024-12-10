import 'package:app_client/pages/fir_screen2.dart';
import 'package:app_client/services/functions/GlobalStartTranscirptionService.dart';
import 'package:app_client/utils/colors.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';

final TextEditingController crimeDescriptionController =
    TextEditingController();

class FillFir extends StatefulWidget {
  const FillFir({super.key});

  @override
  _FillFirState createState() => _FillFirState();
}

class _FillFirState extends State<FillFir> {
  final List<String> weapons = [
    'Knife',
    'Gun',
    'Blunt Object',
    'Explosive',
    'Poison',
    'Other'
  ];
  final List<String> crimeCategories = [
    'Theft',
    'Assault',
    'Fraud',
    'Homicide',
    'Cybercrime',
    'Other'
  ];
  String? selectedWeapon;
  String? selectedCategory;
  DateTime? selectedDate;
  String? placeOfOccurrence;

  bool isRecording = false; // Added flag to track the recording state

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> weaponItems = weapons
        .map((weapon) => DropdownMenuItem(value: weapon, child: Text(weapon)))
        .toList();

    final List<DropdownMenuItem<String>> categoryItems = crimeCategories
        .map((category) =>
            DropdownMenuItem(value: category, child: Text(category)))
        .toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 100),
                        GestureDetector(
                          onTap: () async {
                            await Transcription_service.stopRecording();
                            setState(() {
                              crimeDescriptionController.text = conversation;
                            });
                          },
                          child: Text(
                            "LexiFir",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppBluelight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirAiScreen()));
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Please answer a few questions for a better and accurate response',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Briefly Describe the crime that has happened',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 120,
                      child: TextField(
                        controller: crimeDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          hintText: '',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Select the weapon used:',
                        style: TextStyle(color: Colors.black)),
                    Container(
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        items: weaponItems,
                        onChanged: (value) {
                          selectedWeapon = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: '',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Category of crime:',
                        style: TextStyle(color: Colors.black)),
                    Container(
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        items: categoryItems,
                        onChanged: (value) {
                          selectedCategory = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: '',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Date of occurrence:',
                        style: TextStyle(color: Colors.black)),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? 'Select a date'
                                : '${selectedDate!.toLocal()}'.split(' ')[0],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            hintText: 'Select a date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Place of occurrence:',
                        style: TextStyle(color: Colors.black)),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          placeOfOccurrence = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        hintText: '',
                        suffixIcon: Icon(Icons.pin_drop),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 259,
                  left: 280,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppBlue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          if (isRecording)
                            return; // Prevent multiple recording instances

                          setState(() {
                            isRecording = true;
                          });

                          // Show dialog while recording
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: 500,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppBlue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.mic,
                                          color: AppBluelight, size: 100),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Stop recording and update the conversation in textfield
                                          await Transcription_service
                                              .stopRecording();
                                          setState(() {
                                            crimeDescriptionController.text =
                                                conversation;
                                          });

                                          // Close the dialog
                                          Navigator.pop(context);
                                          setState(() {
                                            isRecording = false;
                                          });
                                        },
                                        child: Text("Stop recording"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          // Initialize and start recording
                          await Transcription_service.initialize();
                          await Transcription_service.startRecording(serverUrl);

                          // Listen for transcription completion
                          Transcription_service.messages.listen((message) {
                            setState(() {
                              conversation = message;
                              crimeDescriptionController.text = message;
                            });

                            // Close the dialog once done

                            setState(() {
                              isRecording = false;
                            });
                          });
                        },
                        icon: Icon(Icons.mic, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
