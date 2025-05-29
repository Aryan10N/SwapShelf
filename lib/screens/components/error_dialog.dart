import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
            ),
            child: const Text('Retry'),
          ),
      ],
    );
  }
} 