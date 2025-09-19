import 'package:flutter/material.dart';
import 'package:petzyyy/screens/adding.dart';
import 'package:petzyyy/screens/profile.dart';
import 'Chat.dart';
import 'notification.dart';
import 'category_section.dart';
import 'package:petzyyy/models/cartpage_.dart';
import 'package:petzyyy/screens/cart_item.dart';
import 'package:petzyyy/screens/AllPetTypespage.dart';
import 'package:petzyyy/screens/all_products_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<CartItem> cartItems = [];

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideFromTop;
  late Animation<Offset> _slideFromBottom;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideFromTop = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideFromBottom = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ChatPage()));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddItemPage()));
    } else if (index == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NotificationPage()));
    } else if (index == 4) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    } else {
      setState(() => _currentIndex = index);
    }
  }

  void _addToCart(String productName, String imageUrl, double price) {
    setState(() {
      cartItems
          .add(CartItem(name: productName, imageUrl: imageUrl, price: price));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$productName added to cart")),
    );
  }

  void _openCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.add, color: Colors.white),
              ),
              label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: _currentIndex == 0
          ? FadeTransition(
              opacity: _fadeIn,
              child: _buildMainContent(),
            )
          : const Center(child: Text('Section not implemented')),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SlideTransition(position: _slideFromTop, child: _buildHeader()),
          const SizedBox(height: 12),
          const CategorySection(),
          SlideTransition(
              position: _slideFromBottom, child: _buildPetTypeSection()),
          SlideTransition(
              position: _slideFromBottom, child: _buildBrandSection()),
          SlideTransition(
              position: _slideFromBottom, child: _buildProductGrid()),
          SlideTransition(position: _slideFromBottom, child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.redAccent, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.redAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(child: SizedBox(height: 10)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '🔍 Search for products',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart,
                        color: Colors.white, size: 28),
                    onPressed: _openCartPage,
                  ),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cartItems.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "🐾 Petzy\nExclusive Deals!\nShop & get up to 5% off",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Image.asset(
                'assets/Group 427321126.png',
                height: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetTypeSection() {
    final petTypes = {
      'Cat': 'assets/cat.png',
      'Dog': 'assets/dog.png',
      'Hen': 'assets/hen.png',
      'Horse': 'assets/horse.png',
      'Goat': 'assets/goat.png',
      'Pigeon': 'assets/pigeon.png',
      'Fish': 'assets/fish.png',
      'Parrot': 'assets/parrot.png',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitleWithImage("Shop by Pet Type", "assets/Vector.png", () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AllPetTypesPage(petTypes: petTypes)),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: petTypes.length,
            itemBuilder: (context, index) {
              final petName = petTypes.keys.elementAt(index);
              final imagePath = petTypes[petName];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(imagePath!, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(petName,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrandSection() {
    final brands = [
      'assets/kanmal.png',
      'assets/me000.png',
      'assets/pet888.png',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: brands
            .map((brand) => CircleAvatar(
                  backgroundImage: AssetImage(brand),
                  radius: 28,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildProductGrid() {
    final productImages = [
      'assets/royalcanin2.png',
      'assets/333royal.png',
      'assets/royal canin.png',
      'assets/4royal.png',
    ];
    return Column(
      children: [
        _sectionTitleWithImage("Products", "assets/Vector.png", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AllProductsPage(products: [],)),
          );
        }),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final productName = "Royal Canin ${index + 1}";
            final imagePath = productImages[index];
            final price = 299.0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(imagePath,
                        height: 110, fit: BoxFit.contain),
                  ),
                  Text(productName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("₹$price", style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _addToCart(productName,
                        "https://i.ibb.co/5rj1QfN/dog-food.jpg", price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Add to Cart"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.pink.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('"Woof Woof"',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            const Text("Follow Petpaw",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 20),
            Image.asset("assets/follow.png", height: 150),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleWithImage(
      String title, String imagePath, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Image.asset(imagePath, height: 24),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          InkWell(
            onTap: onViewAll,
            child: const Text("View All", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
