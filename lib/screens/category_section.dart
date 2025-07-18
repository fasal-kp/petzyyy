import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
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
      'First Aid',
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
      'First Aid': 'assets/First.png',
      'Medicine': 'assets/Medicine.png',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitleWithImage("Product Category", "assets/Vector.png"),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categoriesLine1.length,
            itemBuilder: (context, index) {
              final category = categoriesLine1[index];
              final imagePath = imagePaths[category];
              return _buildCategoryItem(imagePath: imagePath, label: category);
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildCategoryItem({required String? imagePath, required String label}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
            const CircleAvatar(backgroundColor: Colors.orange, radius: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitleWithImage(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset(imagePath, height: 24, width: 24, fit: BoxFit.contain),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Text("View All", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
