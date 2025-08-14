import 'package:flutter/material.dart';

class SuperAdminSettingsPage extends StatelessWidget {
  const SuperAdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Super Admin Dashboard"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const ListTile(
            leading: Icon(Icons.security, color: Colors.redAccent),
            title: Text("Manage Admins"),
            subtitle: Text("Add or remove admin accounts"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.pets, color: Colors.redAccent),
            title: Text("Manage All Pets"),
            subtitle: Text("Full control over pet listings"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.people, color: Colors.redAccent),
            title: Text("Manage Users"),
            subtitle: Text("Add, edit or block users"),
          ),
        ],
      ),
    );
  }
}
