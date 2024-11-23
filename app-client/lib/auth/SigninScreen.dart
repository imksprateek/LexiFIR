import 'package:app_client/auth/LoginScreen.dart';
import 'package:app_client/auth/OTPScreen.dart';
import 'package:app_client/services/functions/sendOTP.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for user input
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController role = TextEditingController(); // Role input

    bool resultFromSendotp;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Signin Screen'),
              // Name input field
              LoginPage_Textfield(
                controller: name,
                HintText: 'Enter your Name',
                LabelText: 'Name',
                Iconer: const Icon(Icons.account_circle, color: Colors.blue),
              ),
              // Role input field
              LoginPage_Textfield(
                controller: role,
                HintText: 'Enter your role',
                LabelText: 'Role',
                Iconer: const Icon(Icons.account_circle, color: Colors.blue),
              ),
              // Email input field
              LoginPage_Textfield(
                controller: email,
                HintText: 'Enter your email',
                LabelText: 'Email',
                Iconer: const Icon(Icons.email, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              // Password input field
              LoginPage_Textfield(
                controller: password,
                HintText: 'Enter password',
                LabelText: 'Password',
                Iconer: const Icon(Icons.lock, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              // Sign up button
              ElevatedButton(
                onPressed: () async {
                  String emailText = email.text;
                  String passwordText = password.text;
                  String nameText = name.text;
                  String roleText = role.text;

                  // Convert role string into a list
                  List<String> roleList = roleText.split(',').map((e) => e.trim()).toList();

                  // Send OTP to the email
                  resultFromSendotp = await sendOTP(emailText);
                  if (resultFromSendotp) {
                    // Navigate to OTP screen with email, password, name, and roles
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(
                          email: emailText,
                          password: passwordText,
                          name: nameText,
                          role: roleList, // Passing roles as a list
                        ),
                      ),
                    );
                    if(SigninSuccessfull)
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Loginscreen())) ;
                      }

                  } else {
                    print('Error sending OTP');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
                    MaterialPageRoute(builder: (context) => const Loginscreen()),
                  );
                },
                child: const Text('Already a member? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Text field widget for user input
class LoginPage_Textfield extends StatelessWidget {
  final String HintText;
  final String LabelText;
  final Icon Iconer;
  final TextEditingController controller;

  const LoginPage_Textfield({
    super.key,
    required this.HintText,
    required this.LabelText,
    required this.Iconer,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: LabelText == 'Password',
      keyboardType: LabelText == 'Email' ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: HintText,
        labelText: LabelText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Iconer,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
