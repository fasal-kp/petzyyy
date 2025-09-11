import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManagePetsPage extends StatelessWidget {
  const ManagePetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Pets"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("pets").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pets found"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final pet = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.pets, color: Colors.deepPurple),
                title: Text(pet["name"] ?? "Unnamed"),
                subtitle: Text(pet["type"] ?? "Unknown"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("pets")
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
