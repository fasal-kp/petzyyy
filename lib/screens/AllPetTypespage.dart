import 'package:flutter/material.dart';

class AllPetTypesPage extends StatelessWidget {
  final Map<String, String> petTypes;
  const AllPetTypesPage({super.key, required this.petTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Pet Types"),
        backgroundColor: Colors.red,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: petTypes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final petName = petTypes.keys.elementAt(index);
          final imagePath = petTypes[petName]!;
          return Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                petName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
