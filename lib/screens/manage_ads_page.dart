import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageAdsPage extends StatelessWidget {
  const ManageAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Ads"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No ads available"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final ad = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.deepPurple),
                title: Text(ad["title"] ?? "No Title"),
                subtitle: Text("₹${ad["price"] ?? 0}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("products")
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
