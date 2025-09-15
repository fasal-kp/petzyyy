import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String imagePath;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.imagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      String photoUrl = widget.imagePath;
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance.ref().child("profile_photos").child("$uid.jpg");
        await ref.putFile(_imageFile!);
        photoUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": widget.email,
        "photoUrl": photoUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text.trim());
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUrl);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (widget.imagePath.isNotEmpty
                        ? NetworkImage(widget.imagePath)
                        : const AssetImage("assets/Avatars.png")) as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}
