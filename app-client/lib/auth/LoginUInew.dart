import 'dart:ui';

import 'package:app_client/auth/SignInScreennew.dart';
import 'package:app_client/auth/SigninScreen.dart';
import 'package:app_client/pages/HomeScreen.dart';
import 'package:app_client/services/functions/Login.dart';
import 'package:app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Welcome Back Officer!\n Enter Your Login Details",
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color of the TextField
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
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
                            height: 15,
                          ),
                          Container(
                            width: 360, // Set desired width

                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color of the TextField
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
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
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () async {
                              String username_text = username.text;
                              String passwordText = password.text;
                              // Perform login with email and password
                              await login(username_text, passwordText);
                              print(
                                  'Email: $username_text, Password: $passwordText');
                              // Add your authentication logic here
                              if (LoginSuccessfull) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'username', username_text);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Homescreen()));
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
                                  "SignIn",
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
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
            ],
          )),
    );
  }
}
