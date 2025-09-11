import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final user = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple),
                title: Text(user["name"] ?? "No Name"),
                subtitle: Text(user["email"] ?? "No Email"),
                trailing: IconButton(
                  icon: const Icon(Icons.block, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(doc.id)
                        .delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
