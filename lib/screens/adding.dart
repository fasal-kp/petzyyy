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

class _AddItemPageState extends State<AddItemPage> {
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

  /// 📷 Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
      if (user == null) {
        throw Exception("User not logged in");
      }

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
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // go back after success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post an Ad"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Text("📷 Tap to upload image"),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              Image.file(_selectedImage!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter item title" : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter item description" : null,
              ),
              const SizedBox(height: 12),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (₹)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter item price" : null,
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? "Select a category" : null,
              ),
              const SizedBox(height: 20),

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Post Ad",
                          style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
