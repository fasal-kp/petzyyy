import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _cart;
  bool _isProcessing = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cartItems);
  }

  /// 🔹 Remove item with animation
  void _removeItem(int index) {
    final removedItem = _cart[index];
    _cart.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // slide out to right
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: FadeTransition(
          opacity: animation,
          child: _buildCartItem(removedItem, index),
        ),
      ),
      duration: const Duration(milliseconds: 400),
    );

    setState(() {});
  }

  /// 🔹 Add item with animation
  void _addItem(Map<String, dynamic> newItem) {
    _cart.add(newItem);
    _listKey.currentState?.insertItem(
      _cart.length - 1,
      duration: const Duration(milliseconds: 400),
    );
    setState(() {});
  }

  /// 🔹 Total price
  double get _totalPrice {
    return _cart.fold(0, (sum, item) => sum + (item['price'] as double? ?? 0));
  }

  /// 🔹 Cart item widget
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: ValueKey(item['id'] ?? index),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeItem(index),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(item['name'], style: const TextStyle(fontSize: 16)),
          subtitle: Text(
            NumberFormat.currency(symbol: "₹", decimalDigits: 2)
                .format(item['price'] ?? 0),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  /// 🔹 Checkout button
  void _checkout() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order placed!")),
      );
      setState(() {
        _cart.clear();
        _isProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 🔹 Example: add new item
              _addItem({
                'id': DateTime.now().toString(),
                'name': 'New Product',
                'price': 299.0,
                'image': 'assets/sample.png', // replace with your asset
              });
            },
          ),
        ],
      ),
      body: _cart.isEmpty
          ? const Center(child: Text("🛒 Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _cart.length,
                    itemBuilder: (context, index, animation) {
                      final item = _cart[index];
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0), // slide in from left
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        )),
                        child: FadeTransition(
                          opacity: animation,
                          child: _buildCartItem(item, index),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "Total: ${NumberFormat.currency(symbol: "₹").format(_totalPrice)}",
                          key: ValueKey(_totalPrice),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _cart.isEmpty || _isProcessing
                            ? null
                            : _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
