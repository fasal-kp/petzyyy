import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategorySection(),
            _buildPetTypeSection(),
            _buildBrandSection(),
            _buildProductGrid(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.yellowAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(child: SizedBox(height: 10)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for products',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.menu),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "🐾 Petzy\nNo Discount!\nShop at Petzy App and get up to 5%",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      'All Products', 'Pellet/Grass Feed', 'Candy', 'Milk Products',
      'Cloth', 'Transport', 'Tools', 'Leash', 'Fashion', 'Collar'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Product Category"),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    CircleAvatar(backgroundColor: Colors.orange, radius: 25),
                    SizedBox(height: 5),
                    Text(categories[index], style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildPetTypeSection() {
    final petTypes = ['Cat', 'Dog', 'Hen', 'Horse'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Products according to pet type"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: petTypes.map((type) => Chip(label: Text(type))).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBrandSection() {
    final brands = ['Pet8', 'Me-O', 'Kanimal'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: brands.map((brand) => Chip(label: Text(brand))).toList(),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(child: Placeholder()),
              SizedBox(height: 8),
              Text("Royal Canin", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Adult Indoor Dry Food", style: TextStyle(fontSize: 12)),
              Text("\$7.99", style: TextStyle(color: Colors.red)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.pink[100],
      child: Column(
        children: [
          Text("Woof Woof", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Follow Petpaw"),
          Image.asset('assets/images/pet_footer.png', height: 100),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("View All", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
