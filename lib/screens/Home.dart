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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
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
              Icon(Icons.shopping_cart, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "🐾 Petzy\nNo Discount!\nShop at Petzy App and get up to 5%",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/Group 427321126.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final categoriesLine1 = [
      'All Products',
      'Pellet/Grass Feed',
      'Candy',
      'Milk Products',
      'Take care of Animals',
      'Parasite control',
      'Bathroom cat sand'
    ];
    final categoriesLine2 = [
      'Training toys',
      'Equipment for providing food',
      'Leash collar',
      'Cloth Fashion',
      'Beauty equipments',
      'Fist Aid',
      'Medicine'
    ];

    final imagePaths = {
      'All Products': 'assets/Group 427321075.png',
      'Pellet/Grass Feed': 'assets/Group 427321079.png',
      'Candy': 'assets/Group 427321078.png',
      'Milk Products': 'assets/Group 427321080.png',
      'Take care of Animals': 'assets/Take.png',
      'Parasite control': 'assets/Parasite.png',
      'Bathroom cat sand': 'assets/Bathroom.png',
      'Training toys': 'assets/Training.png',
      'Equipment for providing food': 'assets/Equipment.png',
      'Leash collar': 'assets/Leash.png',
      'Cloth Fashion': 'assets/Cloth.png',
      'Beauty equipments': 'assets/Beauty.png',
      'Fist Aid': 'assets/First.png',
      'Medicine': 'assets/Medicine.png',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitleWithImage("Product Category", "assets/Vector.png"),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: categoriesLine1.length,
            itemBuilder: (context, index) {
              final category = categoriesLine1[index];
              final imagePath = imagePaths[category];
              return _buildCategoryItem(imagePath: imagePath, label: category);
            },
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: categoriesLine2.length,
            itemBuilder: (context, index) {
              final category = categoriesLine2[index];
              final imagePath = imagePaths[category];
              return _buildCategoryItem(imagePath: imagePath, label: category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
      {required String? imagePath, required String label}) {
    return Container(
      width: 80,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            )
          else
            CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 30,
            ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
        _sectionTitleWithImage(
            "Products according to pet type", "assets/Vector.png"),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: petTypes.length,
            itemBuilder: (context, index) {
              final petName = petTypes.keys.elementAt(index);
              final imagePath = petTypes[petName];

              return Container(
                width: 80,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(imagePath!, fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      petName,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBrandSection() {
    final brands = [];

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
              Text("Royal Canin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
          SizedBox(height: 10),
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
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("View All", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _sectionTitleWithImage(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: 24,
            width: 24,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            "View All",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
