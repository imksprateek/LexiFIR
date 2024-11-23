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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "lib/images/Ellipse1.png",
              fit: BoxFit.cover, // Makes the image fill the width of the screen
              height: 200, // Adjust the height of the circle
            ),
          ),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "LexAI",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      //const SizedBox(height: 5), // Add space below the circle
                      const Text(
                        'Sign-In',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),
                  LoginPage_Textfield(
                    controller: email,
                    HintText: 'Enter your username', // Example hint text
                    LabelText: 'Email', // Example label text
                    Iconer: const Icon(Icons.email,
                        color: Color.fromARGB(255, 72, 10, 1)), // Example icon
                  ),
                  const SizedBox(height: 20), // Add space between the fields
                  LoginPage_Textfield(
                    controller: password,
                    HintText: 'Enter password', // Password hint text
                    LabelText: 'Password', // Password label
                    Iconer: const Icon(Icons.lock,
                        color: Color.fromARGB(255, 47, 24, 0)), // Lock icon
                  ),
                  const SizedBox(
                      height:
                          20), // Add space between the fields and the button
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
                      backgroundColor: const Color.fromARGB(
                          255, 255, 178, 91), // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15), // Padding for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Circular button
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninScreen()));
                    },
                    child: const Text(
                      'Not a member? Signin',
                      style: TextStyle(color: Color.fromRGBO(60, 60, 60, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 77, 46, 0), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 166, 87), width: 2),
        ),
      ),
    );
  }
}
