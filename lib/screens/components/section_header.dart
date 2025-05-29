import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    Key? key,
    required this.title,
    this.trailing,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
} 