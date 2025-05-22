import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurpleLabel extends StatelessWidget {
  final String text;
  const PurpleLabel(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: const Color(0xFF9333EA),
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }
} 