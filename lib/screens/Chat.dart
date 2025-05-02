import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      ),
              backgroundColor: Colors.white,
      body: const Center(child: Text('Welcome to the Chat Page')),
    );
  }
}
