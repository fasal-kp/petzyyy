import 'package:flutter/material.dart';
import 'package:petzyyy/widgets/firestore_service.dart';

class ItemDetailPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> data;

  const ItemDetailPage({super.key, required this.productId, required this.data});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _titleController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data["title"]);
    _priceController = TextEditingController(text: widget.data["price"].toString());
  }

  Future<void> _update() async {
    await _firestoreService.updateProduct(widget.productId, {
      "title": _titleController.text,
      "price": double.tryParse(_priceController.text) ?? 0,
    });
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    await _firestoreService.deleteProduct(widget.productId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data["title"])),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(widget.data["image"], height: 200),
            const SizedBox(height: 20),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: "Price")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _update, child: const Text("Update")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
