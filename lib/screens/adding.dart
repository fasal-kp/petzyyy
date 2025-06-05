import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _chooseFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String? selectedType;
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final types = ['Cat', 'Dog', 'Bird'];
  final categories = ['Food', 'Toy', 'Medicine'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _chooseFile,
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt_outlined),
                      SizedBox(width: 8),
                      Text('Choose a file'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (_image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      const SizedBox(width: 10),
                      imageBox('assets/cat.jpg'),
                      imageBox('assets/dog.jpg'),
                      imageBox('assets/hen.jpg'),
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
                buildTextField('Discription', descriptionController),
                const SizedBox(height: 12),
                buildTextField('Price', priceController, inputType: TextInputType.number),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {
                      // Submit logic here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget imageBox(String path) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
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
        hintText: 'Choose a ${hint.toLowerCase()}',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: InputBorder.none,
      ),
    );
  }
}
