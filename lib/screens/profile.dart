import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petzyyy/screens/LoginScreen.dart';
import 'package:petzyyy/screens/editProfile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 4;
  late AnimationController _controller;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  final List<Map<String, dynamic>> _menuItems = [
    {"icon": Icons.person_outline, "title": "Profile"},
    {"icon": Icons.help_outline, "title": "Help Center"},
    {"icon": Icons.privacy_tip_outlined, "title": "Privacy Policy"},
    {"icon": Icons.payment_outlined, "title": "Payment"},
    {"icon": Icons.language, "title": "Language"},
    {"icon": Icons.category_outlined, "title": "Categories"},
    {"icon": Icons.settings_outlined, "title": "Settings"},
    {"icon": Icons.logout, "title": "Logout"},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _handleTileTap(String title, String name, String phone, String photoUrl) {
    switch (title) {
      case 'Profile':
        _openEditProfile(name, phone, photoUrl);
        break;
      case 'Logout':
        _logoutUser();
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SimplePage(title: title)),
        );
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

  Future<void> _openEditProfile(
      String name, String phone, String photoUrl) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: name,
          phone: phone,
          imagePath: photoUrl, email: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No profile data found"));
          }

          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(child: Text("Profile data is empty"));
          }

          final name = data["name"] ?? "No Name";
          final phone = data["phone"] ?? "No Phone";
          final photoUrl = data["photoUrl"] ?? "";

          return Column(
            children: [
              const SizedBox(height: 30),

              /// Animated Profile Picture
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut,
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: (photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : const AssetImage("assets/Avatars.png")
                              as ImageProvider,
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: GestureDetector(
                        onTap: () => _openEditProfile(name, phone, photoUrl),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: const Icon(Icons.edit,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Text(name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(phone, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 25),

              /// Animated Menu List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _controller,
                              curve: Interval(index * 0.1, 1.0,
                                  curve: Curves.easeOut))),
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                            parent: _controller,
                            curve: Interval(index * 0.1, 1.0,
                                curve: Curves.easeOut)),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.shade50,
                              child: Icon(item["icon"], color: Colors.red),
                            ),
                            title: Text(item["title"],
                                style: const TextStyle(fontSize: 16)),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _handleTileTap(
                                item["title"], name, phone, photoUrl),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      /// Bottom Navigation
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          elevation: 8,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ''),
          ],
        ),
      ),
    );
  }
}

/// Simple placeholder page
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
