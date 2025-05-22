import 'package:flutter/material.dart';
import 'package:swap_shelf/constants.dart';
import 'package:swap_shelf/screens/welcome/welcome_screen.dart';
import 'package:swap_shelf/screens/addBook/add_book_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapShelf',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
