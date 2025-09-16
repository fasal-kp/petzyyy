import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petzyyy/screens/LoginScreen.dart';

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

  void _handleTileTap(String title) {
    switch (title) {
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

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (uid == null || currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          // Default values from FirebaseAuth
          String name = currentUser.displayName ?? "No Name";
          String phone = currentUser.phoneNumber ?? "No Phone";
          String email = currentUser.email ?? "No Email";
          String photoUrl = currentUser.photoURL ?? "";

          // If Firestore data exists, overwrite defaults
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
              const SizedBox(height: 20),

              /// Profile Section
              Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (photoUrl.isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : const AssetImage("assets/Avatars.png")
                            as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(phone, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(email, style: TextStyle(color: Colors.grey[600])),
                ],
              ),

              const SizedBox(height: 25),

              /// Menu Section
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item["icon"],
                            color: Colors.red,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          item["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () => _handleTileTap(item["title"]),
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
