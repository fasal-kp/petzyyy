import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petzyyy/screens/LoginScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final currentUser = FirebaseAuth.instance.currentUser;

  File? _imageFile;
  final picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null || uid == null) return;

    try {
      setState(() => _isUploading = true);
      final storageRef =
          FirebaseStorage.instance.ref().child("user_profiles/$uid.jpg");
      await storageRef.putFile(_imageFile!);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "photoUrl": downloadUrl,
      });
    } catch (e) {
      debugPrint("Upload error: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _logoutUser() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  final List<Map<String, dynamic>> _menuItems = [
    {"icon": Icons.shopping_bag_outlined, "title": "My Ads"},
    {"icon": Icons.payment_outlined, "title": "Payments"},
    {"icon": Icons.favorite_outline, "title": "Favourites"},
    {"icon": Icons.help_outline, "title": "Help & Support"},
    {"icon": Icons.settings_outlined, "title": "Settings"},
    {"icon": Icons.privacy_tip_outlined, "title": "Privacy Policy"},
  ];

  @override
  Widget build(BuildContext context) {
    if (uid == null || currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          String name = currentUser?.displayName ?? "No Name";
          String phone = currentUser?.phoneNumber ?? "No Phone";
          String email = currentUser?.email ?? "No Email";
          String photoUrl = currentUser?.photoURL ?? "";

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data();
            if (data != null) {
              name = data["name"] ?? name;
              phone = data["phone"] ?? phone;
              email = data["email"] ?? email;
              photoUrl = data["photoUrl"] ?? photoUrl;
            }
          }

          return Column(
            children: [
              /// Profile Card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: (photoUrl.isNotEmpty)
                                ? NetworkImage(photoUrl)
                                : const AssetImage("assets/Avatars.png")
                                    as ImageProvider,
                          ),
                          if (_isUploading)
                            const Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.camera_alt,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(phone,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(email,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.red),
                      onPressed: () {
                        // You can add an edit profile page here
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Menu List
              Expanded(
                child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.red.shade50,
                          child: Icon(item["icon"], color: Colors.red),
                        ),
                        title: Text(item["title"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                        onTap: () {
                          // Navigate to respective pages
                        },
                      ),
                    );
                  },
                ),
              ),

              /// Logout Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _logoutUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Logout",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
