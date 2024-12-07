import 'package:app_client/auth/LoginUInew.dart';

import 'package:app_client/services/functions/ValidateOTP.dart'; // Your validate OTP function
import 'package:flutter/material.dart';

import '../SplashScreen.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String password;
  final List<String> role;
  final String name; // Email passed to this screen

  const OTPScreen(
      {super.key,
      required this.email,
      required this.password,
      required this.role,
      required this.name});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  // Focus nodes for text fields
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 30.0), // Add padding to the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the widgets
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter the 6-digit OTP sent to your email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the OTP fields
              children: [
                _buildOTPTextField(_otpController1, _focusNode2),
                const SizedBox(width: 10),
                _buildOTPTextField(_otpController2, _focusNode3),
                const SizedBox(width: 10),
                _buildOTPTextField(_otpController3, _focusNode4),
                const SizedBox(width: 10),
                _buildOTPTextField(
                    _otpController4, FocusNode()), // No focus on the last field
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Combine OTP from each controller
                String otp = _otpController1.text +
                    _otpController2.text +
                    _otpController3.text +
                    _otpController4.text;

                bool isValid = await validateOTP(widget.email, otp,
                    widget.password, widget.role, widget.name);

                if (isValid) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Login()), // Replace HomeScreen with your next screen
                  );
                } else {
                  // OTP is invalid, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid OTP')),
                  );
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
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each OTP text field
  Widget _buildOTPTextField(
      TextEditingController controller, FocusNode? focusNode) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Limit to 1 digit per field
        focusNode: focusNode,
        decoration: InputDecoration(
          counterText: "", // Hide counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded border
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        onChanged: (value) {
          // Automatically focus on the next field when a digit is entered
          if (value.isNotEmpty) {
            FocusScope.of(context).requestFocus(focusNode);
          }
        },
      ),
    );
  }
}
