import 'package:flutter/material.dart';
import 'package:swap_shelf/components/body.dart' show Body;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}