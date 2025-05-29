import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
    return result ?? false;
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
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
} 