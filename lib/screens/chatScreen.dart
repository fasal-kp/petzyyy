import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petzyyy/service/database.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String chatId = "default_chat"; // Replace with real chat ID logic
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _databaseService.createChatIfNotExists(chatId, [widget.userId]);
  }

  void sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _databaseService.sendMessage(chatId, widget.userId, text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3a2144),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Chat Page',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _databaseService.getMessages(chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: false,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];
                      final isMe = data['senderId'] == widget.userId;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.grey.shade200
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(data['message']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
