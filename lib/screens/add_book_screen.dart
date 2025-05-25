import 'package:flutter/material.dart';
import 'package:swap_shelf/models/book.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isAvailable = true;
  bool _isLoading = false;
  Color _selectedColor = Colors.blueAccent;
  File? _selectedImage;
  String? _selectedGenre;
  int _conditionRating = 5;
  final ImagePicker _picker = ImagePicker();

  final List<Color> _availableColors = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
  ];

  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Science Fiction',
    'Fantasy',
    'Romance',
    'Biography',
    'History',
    'Self-Help',
    'Other'
  ];

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isLoading = true);
      
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Compress image
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
          
          setState(() {
            _selectedImage = compressedFile;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImageSourceDialog() {
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
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.black54),
                  title: const Text('Camera', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        // Create a new book object
        final newBook = Book(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          author: _authorController.text,
          description: _descriptionController.text,
          imageUrl: _selectedImage?.path ?? '',
          color: _selectedColor,
          available: _isAvailable,
          isbn: _isbnController.text.isEmpty ? null : _isbnController.text,
          genre: _selectedGenre,
          condition: _conditionRating,
          price: double.tryParse(_priceController.text) ?? 0.0,
          location: _locationController.text.isEmpty ? null : _locationController.text,
        );

        // Show confirmation dialog
        final shouldSave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Confirm Book Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${newBook.title}'),
                  Text('Author: ${newBook.author}'),
                  if (newBook.genre != null) Text('Genre: ${newBook.genre}'),
                  Text('Condition: ${newBook.condition}/5'),
                  if (newBook.price > 0) Text('Price: \$${newBook.price}'),
                  if (newBook.location != null) Text('Location: ${newBook.location}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );

        if (shouldSave == true) {
          Navigator.pop(context, newBook);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving book: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add New Book',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    _buildBasicInfo(),
                    const SizedBox(height: 24),
                    _buildAdditionalInfo(),
                    const SizedBox(height: 24),
                    _buildColorPicker(),
                    const SizedBox(height: 24),
                    _buildAvailabilitySwitch(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Cover',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _selectedImage != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _removeImage,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.black54,
                        size: 50,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add book cover',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: _inputDecoration('Book Title'),
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
        TextFormField(
          controller: _authorController,
          decoration: _inputDecoration('Author Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an author';
            }
            if (value.length > 50) {
              return 'Author name must be less than 50 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: _inputDecoration('Description'),
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
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _isbnController,
          decoration: _inputDecoration('ISBN (Optional)'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length != 10 && value.length != 13) {
              return 'ISBN must be 10 or 13 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGenre,
          decoration: _inputDecoration('Genre'),
          items: _genres.map((genre) {
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
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Condition',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _conditionRating
                        ? Colors.amber
                        : Colors.grey[300],
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _conditionRating = index + 1;
                    });
                  },
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _priceController,
          decoration: _inputDecoration('Price (Optional)'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'Please enter a valid price';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: _inputDecoration('Location'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Cover Color',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableColors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = _availableColors[index];
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: _availableColors[index],
                    shape: BoxShape.circle,
                    border: _selectedColor == _availableColors[index]
                        ? Border.all(color: const Color(0xFF6C63FF), width: 2)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySwitch() {
    return SwitchListTile(
      title: const Text(
        'Available for Swap',
        style: TextStyle(color: Colors.black87),
      ),
      value: _isAvailable,
      activeColor: const Color(0xFF6C63FF),
      onChanged: (value) {
        setState(() {
          _isAvailable = value;
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveBook,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add Book',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}