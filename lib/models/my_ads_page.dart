import 'package:flutter/material.dart';

class MyAdsPage extends StatelessWidget {
  const MyAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Ads")),
      body: const Center(child: Text("Here your ads will appear.")),
    );
  }
}
