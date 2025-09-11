import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection("products");

  /// Create / Add Product
  Future<void> addProduct(Map<String, dynamic> data, String id) async {
    await products.doc(id).set(data);
  }

  /// Read / Fetch Products (Stream for real-time)
  Stream<QuerySnapshot> getProducts() {
    return products.orderBy("createdAt", descending: true).snapshots();
  }

  /// Update Product
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await products.doc(id).update(data);
  }

  /// Delete Product
  Future<void> deleteProduct(String id) async {
    await products.doc(id).delete();
  }
}
