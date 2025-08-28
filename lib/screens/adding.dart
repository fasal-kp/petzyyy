import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final picker = ImagePicker();
  final List<File> _images = [];

  Future<void> _chooseFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (_images.length < 3) {
          _images.add(File(pickedFile.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select up to 3 images')),
          );
        }
      });
    }
  }

  String? selectedType;
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final types = ['Cat', 'Dog', 'Bird'];
  final categories = ['Food', 'Toy', 'Medicine'];

  int _currentIndex = 2; // highlight Add icon
  bool _isLoading = false;

  Future<void> _submitPet() async {
    final type = selectedType;
    final category = selectedCategory;
    final desc = descriptionController.text.trim();
    final price = priceController.text.trim();

    if (_images.isEmpty || type == null || category == null || desc.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select images')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (File image in _images) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('pets')
            .child('${DateTime.now().millisecondsSinceEpoch}_${FirebaseAuth.instance.currentUser?.uid}.jpg');
        await ref.putFile(image);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Save details to Firestore
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
      await FirebaseFirestore.instance.collection('pets').add({
        "type": type,
        "category": category,
        "description": desc,
        "price": price,
        "images": imageUrls,
        "userId": userId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Reset form
      setState(() {
        _images.clear();
        selectedType = null;
        selectedCategory = null;
        descriptionController.clear();
        priceController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text("Add Pet"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _chooseFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 8),
                        Text('Choose a file'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._images.map((file) => imageFileBox(file)).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildDropdown('Type', types, selectedType, (val) {
                  setState(() => selectedType = val);
                }),
                const SizedBox(height: 12),
                buildDropdown('Category', categories, selectedCategory, (val) {
                  setState(() => selectedCategory = val);
                }),
                const SizedBox(height: 12),
                buildTextField('Description', descriptionController),
                const SizedBox(height: 12),
                buildTextField(
                  'Price',
                  priceController,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _submitPet,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                          )
                        : const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // TODO: Navigate to pages if needed
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget imageFileBox(File file) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Choose a ${hint.toLowerCase()}',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: InputBorder.none,
      ),
      value: value,
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: 'Enter $hint',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: InputBorder.none,
      ),
    );
  }
}
