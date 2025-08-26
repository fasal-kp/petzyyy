import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzyyy/screens/phoneAuthScreen.dart'; // your login screen
import 'EditProfilePage.dart'; // edit profile screen

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4;

  String _name = "fasal";
  String _phone = "+91 123456789";
  File? _profileImage;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Example navigation logic
    switch (index) {
      case 0:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
        break;
      case 1:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage()));
        break;
      case 2:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => AddPage()));
        break;
      case 3:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
        break;
      case 4:
        // Already on ProfilePage
        break;
    }
  }

  void _handleTileTap(String title) {
    switch (title) {
      case 'Profile':
        _openEditProfile();
        break;
      case 'Help Center':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SimplePage(title: "Help Center")));
        break;
      case 'Privacy Policy':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SimplePage(title: "Privacy Policy")));
        break;
      case 'Payment':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SimplePage(title: "Payment")));
        break;
      case 'Language':
        _showLanguagePicker();
        break;
      case 'Categories':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SimplePage(title: "Categories")));
        break;
      case 'Settings':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SimplePage(title: "Settings")));
        break;
      case 'Logout':
        _logoutUser();
        break;
    }
  }

  Future<void> _logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Hindi'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Other'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: _name,
          phone: _phone,
          currentImage: _profileImage,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _name = result["name"];
        _profileImage = result["image"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/profile.jpg') as ImageProvider,
              ),
              Positioned(
                child: GestureDetector(
                  onTap: _openEditProfile,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _phone,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                buildListTile(Icons.person_outline, 'Profile'),
                buildListTile(Icons.help_outline, 'Help Center'),
                buildListTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
                buildListTile(Icons.payment_outlined, 'Payment'),
                buildListTile(Icons.language, 'Language'),
                buildListTile(Icons.category_outlined, 'Categories'),
                buildListTile(Icons.settings_outlined, 'Settings'),
                buildListTile(Icons.logout, 'Logout'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget buildListTile(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: Colors.red),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _handleTileTap(title),
      ),
    );
  }
}

/// Simple placeholder page for other items
class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
