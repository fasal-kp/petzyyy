import 'package:flutter/material.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const ListTile(
            leading: Icon(Icons.pets, color: Colors.deepPurple),
            title: Text("Manage Pets"),
            subtitle: Text("Add, edit or remove pet listings"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.people, color: Colors.deepPurple),
            title: Text("View Users"),
            subtitle: Text("See registered users"),
          ),
        ],
      ),
    );
  }
}
