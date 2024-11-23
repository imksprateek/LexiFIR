import 'package:app_client/auth/SigninScreen.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/Login.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
          child: Column(
            // Wrap the text fields in a Column
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("lib/images/Ellipse1.png"),
              const Text('Login Screen'),
              LoginPage_Textfield(
                controller: email,
                HintText: 'Enter your username', // Example hint text
                LabelText: 'Email', // Example label text
                Iconer: const Icon(Icons.contacts_rounded,
                    color: Colors.blue), // Example icon
              ),
              const SizedBox(height: 20), // Add space between the fields
              LoginPage_Textfield(
                controller: password,
                HintText: 'Enter password', // Password hint text
                LabelText: 'Password', // Password label
                Iconer: const Icon(Icons.lock, color: Colors.blue), // Lock icon
              ),
              const SizedBox(
                  height: 20), // Add space between the fields and the button
              ElevatedButton(
                onPressed: () async {
                  // Handle login button press
                  String username_text = email.text;
                  String passwordText = password.text;
                  // Perform login with email and password
                  await login(username_text, passwordText);
                  print('Email: $username_text, Password: $passwordText');
                  // Add your authentication logic here
                  if (LoginSuccessfull) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homescreen()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15), // Padding for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Circular button
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SigninScreen()));
                  },
                  child: const Text('Not a member ? Signin'))
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
  final TextEditingController controller; // Controller for text field input

  const LoginPage_Textfield({
    super.key,
    required this.HintText,
    required this.LabelText,
    required this.Iconer,
    required this.controller, // Pass controller to text field
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Set controller for the text field
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Iconer, // Email or lock icon
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
