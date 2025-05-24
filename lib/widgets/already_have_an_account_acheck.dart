import 'package:flutter/material.dart';
// Assuming you have your constants defined, e.g., in lib/constants/colors.dart
// import 'package:swap_shelf/constants/colors.dart'; // Update with your project name

// Placeholder for your actual color constants if not defined yet
const kPrimaryColor = Colors.teal; // Example, use your app's primary color
const kSecondaryTextColor = Colors.grey; // Example

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login; // True if on login screen, false if on signup screen
  final VoidCallback press;

  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true, // Default to login screen behavior
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: kSecondaryTextColor, fontSize: 15), // Adjust style as needed
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15, // Adjust style as needed
            ),
          ),
        )
      ],
    );
  }
}