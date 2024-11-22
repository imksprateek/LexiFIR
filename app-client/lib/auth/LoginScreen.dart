import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController() ;
    TextEditingController password = TextEditingController() ;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
          child: Column(  // Wrap the text fields in a Column
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginPage_Textfield(
                HintText: 'Enter your email', // Example hint text
                LabelText: 'Email', // Example label text
                Iconer: Icon(Icons.email, color: Colors.blue), // Example icon
              ),
              SizedBox(height: 20),  // Add space between the fields
              LoginPage_Textfield(
                HintText: 'Enter password', // Password hint text
                LabelText: 'Password', // Password label
                Iconer: Icon(Icons.lock, color: Colors.blue), // Lock icon
              ),
            ],
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
      obscureText: LabelText == 'Password', // Hide text for password field
      keyboardType: LabelText == 'Email'
          ? TextInputType.emailAddress
          : TextInputType.text, // Adjust keyboard type based on field
      textInputAction: TextInputAction.done, // Done action on keyboard
      decoration: InputDecoration(
        hintText: HintText, // Placeholder text
        labelText: LabelText, // Label for the text field
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Iconer, // Email or lock icon
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
