import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? const Color(0xFF6C63FF),
            ),
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFF6C63FF),
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
          );

    final buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? (isOutlined ? backgroundColor ?? const Color(0xFF6C63FF) : Colors.white),
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
} 