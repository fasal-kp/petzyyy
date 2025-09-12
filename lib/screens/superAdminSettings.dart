import 'package:flutter/material.dart';

class SuperAdminSettingsPage extends StatelessWidget {
  const SuperAdminSettingsPage({super.key});

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
        title: const Text("Super Admin Dashboard"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          DashboardTile(
            icon: Icons.security,
            title: "Manage Admins",
            subtitle: "Add or remove admin accounts",
            color: Colors.redAccent,
            onTap: () {
              _navigate(context, const ManageAdminsPage());
            },
          ),
          DashboardTile(
            icon: Icons.pets,
            title: "Manage All Pets",
            subtitle: "Full control over pet listings",
            color: Colors.orangeAccent,
            onTap: () {
              _navigate(context, const ManagePetsPage());
            },
          ),
          DashboardTile(
            icon: Icons.people,
            title: "Manage Users",
            subtitle: "Add, edit or block users",
            color: Colors.blueAccent,
            onTap: () {
              _navigate(context, const ManageUsersPage());
            },
          ),
          DashboardTile(
            icon: Icons.settings,
            title: "System Settings",
            subtitle: "App-wide configuration",
            color: Colors.green,
            onTap: () {
              _navigate(context, const SystemSettingsPage());
            },
          ),
        ],
      ),
    );
  }
}

/// Reusable Dashboard Tile Widget
class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const DashboardTile({
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}

/// Dummy Pages (replace with your real pages)
class ManageAdminsPage extends StatelessWidget {
  const ManageAdminsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Manage Admins")), body: const Center(child: Text("Admin management here")));
  }
}

class ManagePetsPage extends StatelessWidget {
  const ManagePetsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Manage Pets")), body: const Center(child: Text("Pet listings management here")));
  }
}

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Manage Users")), body: const Center(child: Text("User management here")));
  }
}

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("System Settings")), body: const Center(child: Text("System-wide settings here")));
  }
}
