// File: lib/screens/welcome/components/login_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If you use SVGs for background or logo
import 'package:swap_shelf/screens/login/login_screen.dart';   // <<<--- IMPORTANT: Import LoginScreen
import '../../signup/signup_page.dart'; // <<<--- IMPORTANT: Import SignUpScreen
// import 'package:swap_shelf/constants/colors.dart'; // Your app's color constants

// Placeholder for your actual color constants if not defined yet
const kPrimaryColor = Colors.teal; // Example, use your app's primary color
const kPrimaryLightColor = Color(0xFFB2DFDB); // Example, a lighter shade for the signup button

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // This size provides screen dimensions

    return SizedBox( // This is the main background container for the Welcome Screen
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png", // Replace with your actual welcome screen top image
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0, // Or right, depending on your design
            child: Image.asset(
              "assets/images/main_bottom.png", // Replace with your actual welcome screen bottom image
              width: size.width * 0.2,
            ),
          ),
          SingleChildScrollView( // To prevent overflow if content is too long
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "WELCOME TO SWAP_SHELF",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                SizedBox(height: size.height * 0.05),
                SvgPicture.asset(
                  "assets/icons/chat.svg", // Replace with your app's welcome illustration
                  height: size.height * 0.45,
                ),
                SizedBox(height: size.height * 0.05),

                // LOGIN Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: kPrimaryColor, // Use your theme's primary color
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen(); // Navigate to LoginScreen
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),

                // SIGNUP Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: kPrimaryLightColor, // A different color for signup
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                      onPressed: () {
                        // <<< --- ACTION FOR SIGNUP BUTTON --- >>>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // Ensure you have SignUpScreen created and imported
                              return const SignUpScreen(); // Navigate to SignUpScreen
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.black, fontSize: 17), // Text color that contrasts with button
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}