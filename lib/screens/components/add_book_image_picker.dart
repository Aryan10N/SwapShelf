import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class AddBookImagePicker extends StatelessWidget {
  final String? imagePath;
  final Function(String?) onImageSelected;

  const AddBookImagePicker({
    Key? key,
    required this.imagePath,
    required this.onImageSelected,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
        
        if (image != null) {
          final img.Image resized = img.copyResize(
            image,
            width: 800,
            height: 800,
            interpolation: img.Interpolation.linear,
          );
          
          final compressedBytes = img.encodeJpg(resized, quality: 85);
          final compressedFile = File(pickedFile.path)
            ..writeAsBytesSync(compressedBytes);
          
          onImageSelected(compressedFile.path);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Select Image Source',
            style: TextStyle(color: Colors.black87),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.black54),
                  title: const Text('Photo Gallery', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.black54),
                  title: const Text('Camera', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Cover Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imagePath != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => onImageSelected(null),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Image'),
                    onPressed: () => _showImageSourceDialog(context),
                  ),
                ),
        ),
      ],
    );
  }
} 