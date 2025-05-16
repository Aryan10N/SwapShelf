import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If you are using an SVG for illustration
import 'package:swap_shelf/widgets/already_have_an_account_acheck.dart';
// Import your app's constants (e.g., for colors) if you have them
// import 'package:swap_shelf/constants/colors.dart';
// Import the SignUpScreen for navigation
// import 'package:swap_shelf/screens/signup/signup_screen.dart';
// Import a HomeScreen or similar for navigation after successful login
// import 'package:swap_shelf/screens/home/home_screen.dart';


// Placeholder for your actual color constants if not defined centrally
const kPrimaryColor = Colors.teal; // Example: Use your app's primary color
const kSecondaryTextColor = Colors.grey; // Example

class Body extends StatefulWidget { // Changed to StatefulWidget to manage form state
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>(); // Key for the Form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator during login attempt

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    // First, validate the form inputs
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, do nothing further
    }

    // If form is valid, proceed with login
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // --- !!! Placeholder for your Actual Authentication Logic !!! ---
    // In a real application, you would call your authentication service here
    // (e.g., Firebase Auth, your own backend API)
    print("Attempting login with Email: $email, Password: $password");
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Example: Replace this with actual success/failure from auth service
    bool loginSuccessful = (email == "test@example.com" && password == "password123"); // Dummy check

    // --- End of Placeholder ---

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (loginSuccessful) {
      print("Login Successful!");
      // Navigate to the HomeScreen (or your app's main screen after login)
      // Ensure HomeScreen is created and imported
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful! (Navigating to home...)')),
      );
    } else {
      print("Login Failed!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container( // Main container for background and layout
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background Images (like in the video)
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png", // Ensure this asset exists
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0, // Corrected from 'left' in some previous examples if it's the login_bottom.png
            child: Image.asset(
              "assets/images/login_bottom.png", // Ensure this asset exists
              width: size.width * 0.4,
            ),
          ),
          SingleChildScrollView( // To allow scrolling if content overflows
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08), // Overall horizontal padding
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.04), // Top spacing
                    Text(
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Optional: SVG Illustration
                    SvgPicture.asset(
                      "assets/icons/login.svg", // Ensure this asset exists
                      height: size.height * 0.30,
                    ),
                    SizedBox(height: size.height * 0.03),

                    // Email TextFormField
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(29),
                        ),
                        filled: true,
                        fillColor: kPrimaryColor.withAlpha(40), // Light background for the field
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),

                    // Password TextFormField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, // Hides password input
                      decoration: InputDecoration(
                        hintText: "Your Password",
                        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                        // Consider adding a suffixIcon to toggle password visibility
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(29),
                        ),
                        filled: true,
                        fillColor: kPrimaryColor.withAlpha(40),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),

                    // Login Button or Loading Indicator
                    _isLoading
                        ? CircularProgressIndicator(color: kPrimaryColor)
                        : Container(
                      width: size.width * 0.8, // Button takes 80% of screen width
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                          ),
                          onPressed: _loginUser, // Calls the login function
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    // "Don't have an account?" Check
                    AlreadyHaveAnAccountCheck(
                      login: true, // true because this is the Login screen
                      press: () {
                        // Navigate to SignUpScreen
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return SignUpScreen(); // Ensure SignUpScreen is imported
                        //     },
                        //   ),
                        // );
                        print("Navigate to Sign Up Screen (Not implemented yet)");
                      },
                    ),
                    SizedBox(height: size.height * 0.05), // Bottom spacing
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}