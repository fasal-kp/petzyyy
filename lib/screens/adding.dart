import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage>
    with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  final List<File> _images = [];

  String? selectedType;
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final types = ['Cat', 'Dog', 'Bird'];
  final categories = ['Food', 'Toy', 'Medicine'];

  int _currentIndex = 2;
  bool _isLoading = false;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  /// Pick image
  Future<void> _chooseFile() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (_images.length < 3) {
            _images.add(File(pickedFile.path));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('⚠️ You can only select up to 3 images')),
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  /// Upload pet
  Future<void> _submitPet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please login first')),
      );
      return;
    }

    final type = selectedType;
    final category = selectedCategory;
    final desc = descriptionController.text.trim();
    final price = priceController.text.trim();

    if (_images.isEmpty ||
        type == null ||
        category == null ||
        desc.isEmpty ||
        price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill all fields and add images')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload images to Firebase Storage
      final List<String> imageUrls = [];
      for (final image in _images) {
        final id = const Uuid().v4();
        final ref = FirebaseStorage.instance.ref().child('pets/$id.jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Save pet data to Firestore
      final docRef = FirebaseFirestore.instance.collection('pets').doc();
      await docRef.set({
        'id': docRef.id,
        'type': type,
        'category': category,
        'description': desc,
        'price': double.tryParse(price) ?? 0,
        'images': imageUrls,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      if (!mounted) return;
      setState(() {
        _images.clear();
        selectedType = null;
        selectedCategory = null;
        descriptionController.clear();
        priceController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pet submitted successfully!')),
      );
    } on FirebaseException catch (e) {
      debugPrint('Firebase ERROR: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: ${e.message}')),
      );
    } catch (e) {
      debugPrint('Unexpected ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Animation wrapper
  Widget animatedItem({required int index, required Widget child}) {
    final intervalStart = index * 0.1;
    final intervalEnd = intervalStart + 0.5;

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text('Add Pet'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload button
                animatedItem(
                  index: 0,
                  child: GestureDetector(
                    onTap: _chooseFile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(width: 8),
                          Text('Choose a file'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Image previews
                animatedItem(
                  index: 1,
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _images
                          .map((f) => imageFileBox(f))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdowns + fields
                animatedItem(
                  index: 2,
                  child: buildDropdown('Type', types, selectedType,
                      (val) => setState(() => selectedType = val)),
                ),
                const SizedBox(height: 12),

                animatedItem(
                  index: 3,
                  child: buildDropdown('Category', categories, selectedCategory,
                      (val) => setState(() => selectedCategory = val)),
                ),
                const SizedBox(height: 12),

                animatedItem(
                  index: 4,
                  child: buildTextField('Description', descriptionController,
                      maxLines: 3),
                ),
                const SizedBox(height: 12),

                animatedItem(
                  index: 5,
                  child: buildTextField('Price', priceController,
                      inputType: TextInputType.number),
                ),
                const SizedBox(height: 20),

                // Submit button
                animatedItem(
                  index: 6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitPet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Submit'),
                    ),
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
          setState(() => _currentIndex = index);
          // TODO: add navigation to actual pages
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

  /// Image preview with remove option
  Widget imageFileBox(File file) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
            image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _images.remove(file);
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown(
      String hint, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Choose a ${hint.toLowerCase()}',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: 'Enter $hint',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
