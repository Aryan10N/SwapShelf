import 'package:flutter/material.dart';
import 'package:swap_shelf/screens/signup/components/socialiconbutton.dart';
import 'package:swap_shelf/widgets/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryLightColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryLightColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          // ... (likely below your email/password form and signup button)

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("OR", style: TextStyle(color: Colors.grey.shade600)),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Google Button
              SocialIconButton(
                iconPath: "assets/icons/google-plus.svg", // Replace with your asset path
                onTap: () {
                 //  _signInWithGoogle(); // We'll define this function later
                },
              ),
              SizedBox(width: 20),

              // Facebook Button
              SocialIconButton(
                iconPath: "assets/icons/facebook.svg", // Replace with your asset path
                onTap: () {
                  // _signInWithFacebook(); // We'll define this function later
                },
              ),
              SizedBox(width: 20),

              // Twitter Button
              SocialIconButton(
                iconPath: "assets/icons/twitter.svg", // Replace with your asset path
                onTap: () {
                 //  _signInWithTwitter(); // We'll define this function later
                },
              ),
            ],
          ),

          // ... (rest of your signup page, e.g., "Already have an account?")
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {},
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}