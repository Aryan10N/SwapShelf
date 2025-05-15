import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swap_shelf/screens/components/background.dart';

class Body extends StatelessWidget {
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
                onPressed: () {},
                child: Text("LOGIN"),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: ElevatedButton(
                onPressed: () {},
                child: Text("SIGNUP",
                ),
            ),
          ),
        ],
      ),
    );
  }
}
