// File: lib/widgets/social_icon_button.dart (or similar)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12), // Adjust padding
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        // If using SVGs:
        child: SvgPicture.asset(
          iconPath,
          height: 30, // Adjust size
          width: 30,  // Adjust size
        ),
        // If using IconData (e.g., from FontAwesome):
        // child: Icon(iconData, size: 30, color: Colors.black),
      ),
    );
  }
}