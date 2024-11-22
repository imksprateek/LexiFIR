import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
          child: LoginPage_Textfield(
            HintText: 'Enter your email', // Example hint text
            LabelText: 'Email', // Example label text
            Iconer: Icon(Icons.email, color: Colors.blue), // Example icon
          ),
        ),
      ),
    );
  }
}

class LoginPage_Textfield extends StatelessWidget {
  final String HintText;
  final String LabelText;
  final Icon Iconer;

  const LoginPage_Textfield({
    super.key,
    required this.HintText,
    required this.LabelText,
    required this.Iconer,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress, // Email keyboard
      textInputAction: TextInputAction.done, // Done action on keyboard
      decoration: InputDecoration(
        hintText: HintText, // Placeholder text
        labelText: LabelText, // Label for the text field
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Iconer, // Email icon
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
