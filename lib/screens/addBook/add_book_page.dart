import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/rounded_text_field.dart';
import 'components/purple_label.dart';
import 'components/gradient_button.dart';
import 'components/cover_upload_avatar.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  bool isAvailableForLending = false;
  // Placeholder for image file
  // File? _coverImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'Add a Book',
            style: GoogleFonts.poppins(
              color: const Color(0xFF9333EA),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const CoverUploadAvatar(),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Tap to upload book cover',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const PurpleLabel('Book Title *'),
              const SizedBox(height: 8),
              const RoundedTextField(hintText: 'Enter book title'),
              const SizedBox(height: 18),
              const PurpleLabel('Author Name'),
              const SizedBox(height: 8),
              const RoundedTextField(hintText: 'Enter author name'),
              const SizedBox(height: 18),
              const PurpleLabel('Subject or Category'),
              const SizedBox(height: 8),
              const RoundedTextField(hintText: 'e.g. Science, Fiction'),
              const SizedBox(height: 18),
              const PurpleLabel('Book Description'),
              const SizedBox(height: 8),
              const RoundedTextField(
                hintText: 'Write something about the book...',
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PurpleLabel('Available for Lending'),
                  Switch(
                    value: isAvailableForLending,
                    activeColor: const Color(0xFF9333EA),
                    onChanged: (val) {
                      setState(() {
                        isAvailableForLending = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/book_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              GradientButton(
                text: 'List Book',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
} 