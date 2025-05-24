
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swap_shelf/components/background.dart';
import 'package:swap_shelf/screens/login/login_screen.dart';

import '../screens/signup/signup_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              "SWAP SHELF",
              style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.3),
          SizedBox(
            width: 250,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                      MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                },
                child: Text("LOGIN"),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen())
                  );
                },
                child: Text(
                  "SIGNUP",
                ),
            ),
          ),
        ],
      ),
    );
  }
}