import 'package:flutter/material.dart';
import 'manage_pets_page.dart';
import 'manage_users_page.dart';
import 'manage_ads_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
          _buildAdminTile(
            context,
            icon: Icons.pets,
            title: "Manage Pets",
            subtitle: "Add, edit or remove pet listings",
            page: const ManagePetsPage(),
          ),
          const Divider(),
          _buildAdminTile(
            context,
            icon: Icons.people,
            title: "Manage Users",
            subtitle: "View and control registered users",
            page: const ManageUsersPage(),
          ),
          const Divider(),
          _buildAdminTile(
            context,
            icon: Icons.shopping_bag,
            title: "Manage Ads",
            subtitle: "Approve or delete user ads",
            page: const ManageAdsPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple, size: 32),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
    );
  }
}
