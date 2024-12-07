import 'dart:ui';

import 'package:app_client/auth/SignInScreennew.dart';
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  SizedBox(
                    height: screenHeight * 0.1, // 10% of the screen height
                  ),
                  Text(
                    "LexiAI",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: screenHeight * 0.08, // Responsive font size
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
                    height: screenHeight * 0.7, // 70% of screen height
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(83, 158, 158, 158),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.03, // 7% of screen height
                        ),
                        Text(
                          "Welcome Back Officer!\n Enter Your Login Details",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: screenHeight * 0.07, // 7% of screen height
                        ),
                        Container(
                          width: screenWidth * 0.9, // 90% of screen width
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2),
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
                        SizedBox(
                          height: screenHeight * 0.02, // 2% of screen height
                        ),
                        Container(
                          width: screenWidth * 0.9, // 90% of screen width
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 7,
                                offset: Offset(0, 2),
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
                        SizedBox(
                          height: screenHeight * 0.05, // 5% of screen height
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
                            width: screenWidth * 0.8, // 80% of screen width
                            height: screenHeight * 0.07, // Responsive height
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 21, 39),
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
                        SizedBox(
                          height: screenHeight * 0.02, // 2% of screen height
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
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/images/google.png",
                              height: screenHeight * 0.08, // 10% of screen height
                            ),
                            Image.asset(
                              "lib/images/apple.png",
                              height: screenHeight * 0.08, // 10% of screen height
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05, // 5% of screen height
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
        ),
      ),
    );
  }
}
