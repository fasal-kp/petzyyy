import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  Future<void> _toggleBlockUser(BuildContext context, String docId, bool isBlocked) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBlocked ? "Unblock User" : "Block User"),
        content: Text(
          "Are you sure you want to ${isBlocked ? "unblock" : "block"} this user?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isBlocked ? Colors.green : Colors.red,
            ),
            child: Text(isBlocked ? "Unblock" : "Block"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection("users").doc(docId).update({
        "isBlocked": !isBlocked,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBlocked ? "User unblocked" : "User blocked"),
        ),
      );
    }
  }

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
            padding: const EdgeInsets.all(12),
            children: snapshot.data!.docs.map((doc) {
              final user = doc.data() as Map<String, dynamic>;
              final isBlocked = user["isBlocked"] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  title: Text(
                    user["name"] ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user["email"] ?? "No Email"),
                  trailing: IconButton(
                    icon: Icon(
                      isBlocked ? Icons.lock_open : Icons.block,
                      color: isBlocked ? Colors.green : Colors.red,
                    ),
                    onPressed: () => _toggleBlockUser(context, doc.id, isBlocked),
                  ),
                  onTap: () {
                    // 🔹 Optional: show full user details
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(user["name"] ?? "User Details"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${user["email"] ?? "N/A"}"),
                            Text("Role: ${user["role"] ?? "User"}"),
                            Text("Status: ${isBlocked ? "Blocked" : "Active"}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
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
