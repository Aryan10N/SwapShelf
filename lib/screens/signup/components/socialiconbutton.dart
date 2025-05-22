
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialIconButton({
    Key? key,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        // If using SVGs:
        child: SvgPicture.asset(
          iconPath,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}