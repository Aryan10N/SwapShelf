import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? prefixText;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.prefixText,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      enabled: enabled,
      focusNode: focusNode,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF6C63FF),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        filled: true,
        fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
} 