import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;
  String? _selectedCategory;

  final List<String> _categories = [
    "Mobiles",
    "Vehicles",
    "Pets",
    "Electronics",
    "Furniture",
    "Fashion",
    "Jobs",
    "Others",
  ];

  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  /// 📷 Pick image from gallery/camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Choose Image"),
        children: [
          SimpleDialogOption(
            child: const Text("📷 Camera"),
            onPressed: () async {
              Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
            },
          ),
          SimpleDialogOption(
            child: const Text("🖼️ Gallery"),
            onPressed: () async {
              Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
            },
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  /// 🔹 Upload item to Firebase
  Future<void> _uploadItem() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please fill all fields and pick an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final id = const Uuid().v4();

      // Upload image to Firebase Storage
      final ref =
          FirebaseStorage.instance.ref().child("products").child("$id.jpg");
      await ref.putFile(_selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      // Save product to Firestore
      await FirebaseFirestore.instance.collection("products").doc(id).set({
        "id": id,
        "title": _titleController.text.trim(),
        "description": _descController.text.trim(),
        "price": double.tryParse(_priceController.text.trim()) ?? 0,
        "category": _selectedCategory,
        "image": imageUrl,
        "userId": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Item added successfully"),
            backgroundColor: Colors.green,
          ),
        );
        // Clear form
        _formKey.currentState!.reset();
        _titleController.clear();
        _descController.clear();
        _priceController.clear();
        setState(() {
          _selectedImage = null;
          _selectedCategory = null;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("❌ Error: ${e.toString()}"),
              backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 Gradient Background (Petzy Theme)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF9A9E), // soft pink
                    Color(0xFFFAD0C4), // peach
                    Color(0xFFFBC2EB), // light purple
                    Color(0xFFA18CD1), // soft violet
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          /// ✨ Fade-in form with card style
          FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "✨ Post a New Ad",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(height: 20),

                          // 📷 Image Picker
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: _selectedImage == null
                                  ? const Center(
                                      child: Text("📷 Tap to upload image",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54)),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(_selectedImage!,
                                          fit: BoxFit.cover),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          _buildTextField(_titleController, "Title",
                              "Enter item title"),
                          const SizedBox(height: 14),

                          // Description
                          _buildTextField(_descController, "Description",
                              "Enter item description",
                              maxLines: 3),
                          const SizedBox(height: 14),

                          // Price
                          _buildTextField(_priceController, "Price (₹)",
                              "Enter item price",
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 14),

                          // Category
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration("Category"),
                            value: _selectedCategory,
                            items: _categories
                                .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.category,
                                              color: Colors.redAccent),
                                          const SizedBox(width: 8),
                                          Text(cat),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
                            validator: (value) =>
                                value == null ? "Select a category" : null,
                          ),
                          const SizedBox(height: 25),

                          // Post Button
                          ElevatedButton(
                            onPressed: _isUploading ? null : _uploadItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                            ),
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("🚀 Post Ad",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// ⏳ Loading Overlay
          if (_isUploading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔹 Input field builder
  Widget _buildTextField(TextEditingController controller, String label,
      String hint,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) return hint;
        if (label == "Price (₹)" && double.tryParse(value) == null) {
          return "Enter a valid price";
        }
        return null;
      },
    );
  }

  /// 🔹 Stylish Input Decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Colors.white,
    );

    
  }
}
