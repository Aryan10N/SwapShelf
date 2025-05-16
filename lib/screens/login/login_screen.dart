import 'package:flutter/material.dart';
import '../../components/body.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(), // Use the extracted Body widget here
    );
  }
}