import 'dart:ui';

import 'package:app_client/auth/LoginUInew.dart';
import 'package:app_client/auth/OTPScreen.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/CheckUserExistence.dart';
import 'package:app_client/services/functions/Login.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _chosenvalue;
  String? role;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController confirmpassword = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/images/bgimage.png"), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "LexiAI",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 50,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 700,
                      width: 460,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(83, 158, 158, 158),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              "Hello User Please Create a new account",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: 360, // Set desired width
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the TextField
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Subtle shadow
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Enter Your Email ",
                                    prefixIcon: Icon(Icons.person)),
                                controller: email,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 360, // Set desired width
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the TextField
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Subtle shadow
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Enter Your Name ",
                                    prefixIcon: Icon(Icons.person)),
                                controller: username,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 360,
                              decoration: BoxDecoration(
                                color: Colors.white, // White background color
                                borderRadius: BorderRadius.circular(
                                    15), // Optional: Add rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10), // Add some padding
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.work),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      //elevation: 5,
                                      focusColor: Colors.white,
                                      dropdownColor: Colors
                                          .white, // Dropdown menu background color
                                      value: _chosenvalue,
                                      style: const TextStyle(
                                        color: Colors.black, // Text color
                                      ),
                                      iconEnabledColor:
                                          Colors.black, // Dropdown icon color
                                      items: <String>[
                                        'user',
                                        'admin',
                                        'moderator',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors
                                                    .black), // Text color in items
                                          ),
                                        );
                                      }).toList(),
                                      hint: const Text(
                                        "Please Select a Role",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _chosenvalue = value;
                                          role =
                                              _chosenvalue; // Update the selected value
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 360, // Set desired width

                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the TextField
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.6), // Subtle shadow
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    prefixIcon: Icon(Icons.password)),
                                controller: password,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 360, // Set desired width

                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the TextField
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.6), // Subtle shadow
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icon(Icons.password)),
                                controller: confirmpassword,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                String emailText = email.text.trim();
                                String passwordText = password.text.trim();
                                String nameText = username.text.trim();
                                String roleText = role!;

                                // Convert role string into a list
                                List<String> roleList = roleText
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();
                                await checkUserExists(nameText, emailText,
                                    passwordText, roleList);
                                // Send OTP to the email

                                if (resultFromSendotp) {
                                  // Navigate to OTP screen with email, password, name, and roles
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                        email: emailText,
                                        password: passwordText,
                                        name: nameText,
                                        role:
                                            roleList, // Passing roles as a list
                                      ),
                                    ),
                                  );
                                  if (SigninSuccessfull) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  }
                                } else {
                                  print('Error sending OTP');
                                }
                              },
                              child: Container(
                                width: 300,
                                height: 49.5,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 0, 21, 39),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "__________________________",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Or",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "__________________________",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/images/google.png",
                                  height: 60,
                                ),
                                Image.asset(
                                  "lib/images/apple.png",
                                  height: 60,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                              },
                              child: Text(
                                "Not a member? Register Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
