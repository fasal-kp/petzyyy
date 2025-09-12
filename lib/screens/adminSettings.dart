import 'package:flutter/material.dart';
import 'manage_pets_page.dart';
import 'manage_users_page.dart';
import 'manage_ads_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🐾 Petzy Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          AdminTile(
            icon: Icons.pets,
            title: "Manage Pets",
            subtitle: "Add, edit or remove pet listings",
            color: Colors.deepPurple,
            onTap: () => _navigate(context, const ManagePetsPage()),
          ),
          AdminTile(
            icon: Icons.people,
            title: "Manage Users",
            subtitle: "View and control registered users",
            color: Colors.blueAccent,
            onTap: () => _navigate(context, const ManageUsersPage()),
          ),
          AdminTile(
            icon: Icons.shopping_bag,
            title: "Manage Ads",
            subtitle: "Approve or delete user ads",
            color: Colors.orangeAccent,
            onTap: () => _navigate(context, const ManageAdsPage()),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Reusable AdminTile
class AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const AdminTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
