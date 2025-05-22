import 'package:flutter/material.dart';

class CoverUploadAvatar extends StatelessWidget {
  const CoverUploadAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9333EA),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: const Color(0xFF9333EA),
              size: 38,
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 18,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.edit,
              color: Color(0xFF9333EA),
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
} 