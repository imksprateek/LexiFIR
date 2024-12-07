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
                        fontSize: screenWidth * 0.12, // 12% of the screen width
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
                    height: screenHeight * 0.8, // 80% of the screen height
                    width: screenWidth *1, // 90% of the screen width
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
                          SizedBox(
                            height: screenHeight * 0.03, // 5% of the screen height
                          ),
                          Text(
                            "Hello User Please Create a new account",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          _buildTextField(
                            controller: email,
                            hintText: "Enter Your Email",
                            icon: Icons.email,
                            width: screenWidth * 0.9,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: username,
                            hintText: "Enter Your Name",
                            icon: Icons.person,
                            width: screenWidth * 0.9,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildRoleDropdown(screenWidth * 1.12),
                          SizedBox(height: screenHeight * 0.022),
                          _buildTextField(
                            controller: password,
                            hintText: "Enter your password",
                            icon: Icons.password,
                            width: screenWidth * 0.9,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: confirmpassword,
                            hintText: "Confirm Password",
                            icon: Icons.password,
                            width: screenWidth * 0.9,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildSubmitButton(screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.02),
                          _buildOrRow(),
                          SizedBox(height: screenHeight * 0.05),
                          _buildSocialMediaIcons(),
                          SizedBox(height: screenHeight * 0.01),
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(double screenWidth) {
    return Container(
      width: screenWidth * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.work),
          const SizedBox(width: 20),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _chosenvalue,
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
                  role = _chosenvalue;
                });
              },
              items: <String>[
                'user',
                'admin',
                'moderator',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () async {
        String emailText = email.text.trim();
        String passwordText = password.text.trim();
        String nameText = username.text.trim();
        String roleText = role!;

        // Convert role string into a list
        List<String> roleList = roleText.split(',').map((e) => e.trim()).toList();
        await checkUserExists(nameText, emailText, passwordText, roleList);

        if (resultFromSendotp) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: emailText,
                password: passwordText,
                name: nameText,
                role: roleList,
              ),
            ),
          );
          if (SigninSuccessfull) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Login()));
          }
        } else {
          print('Error sending OTP');
        }
      },
      child: Container(
        width: screenWidth * 0.75,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 21, 39),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "SignUp",
            style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildOrRow() {
    return Row(
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
    );
  }

  Widget _buildSocialMediaIcons() {
    return Row(
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
    );
  }
}
