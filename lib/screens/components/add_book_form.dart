import 'package:flutter/material.dart';
import 'package:swap_shelf/screens/components/custom_form_field.dart';
import 'package:swap_shelf/screens/components/section_header.dart';
import 'package:swap_shelf/screens/components/custom_button.dart';

class AddBookForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final List<String> genres;
  final List<Color> availableColors;

  const AddBookForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
    required this.genres,
    required this.availableColors,
  }) : super(key: key);

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _isbnController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  
  String? _selectedGenre;
  String? _selectedCondition;
  Color? _selectedColor;
  bool _isAvailable = true;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _isbnController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'title': _titleController.text,
        'author': _authorController.text,
        'description': _descriptionController.text,
        'isbn': _isbnController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'location': _locationController.text,
        'genre': _selectedGenre,
        'condition': _selectedCondition,
        'color': _selectedColor,
        'isAvailable': _isAvailable,
      };
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: 'Basic Information',
            padding: EdgeInsets.only(bottom: 16),
          ),
          CustomFormField(
            controller: _titleController,
            label: 'Title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              if (value.length > 100) {
                return 'Title must be less than 100 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _authorController,
            label: 'Author',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an author';
              }
              if (value.length > 100) {
                return 'Author name must be less than 100 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _descriptionController,
            label: 'Description',
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              if (value.length > 500) {
                return 'Description must be less than 500 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Additional Information',
            padding: EdgeInsets.only(bottom: 16),
          ),
          CustomFormField(
            controller: _isbnController,
            label: 'ISBN',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ISBN';
              }
              if (value.length != 10 && value.length != 13) {
                return 'ISBN must be 10 or 13 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _priceController,
            label: 'Price',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _locationController,
            label: 'Location',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGenre,
            decoration: InputDecoration(
              labelText: 'Genre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: widget.genres.map((genre) {
              return DropdownMenuItem(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGenre = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a genre';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Book Condition',
            padding: EdgeInsets.only(bottom: 16),
          ),
          DropdownButtonFormField<String>(
            value: _selectedCondition,
            decoration: InputDecoration(
              labelText: 'Condition',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: ['New', 'Like New', 'Very Good', 'Good', 'Fair', 'Poor']
                .map((condition) {
              return DropdownMenuItem(
                value: condition,
                child: Text(condition),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCondition = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a condition';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Book Color',
            padding: EdgeInsets.only(bottom: 16),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.availableColors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color
                          ? Colors.black
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Available for Swap'),
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Book',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
} 