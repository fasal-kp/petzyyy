import 'package:flutter/material.dart';
import 'chatScreen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
              color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.add, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Pinned',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _pinnedCard(
                    "Abram",
                    "Yesterday",
                    "I would like to your consent on upcoming meeting...",
                    false,
                    "assets/Avatars.png"),
                const SizedBox(width: 12),
                _pinnedCard("Ruben", "3:39 pm",
                    "You have not been up for tennis match? Are you OK?", true,
                    "assets/Avatars.png"),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Recent',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _chatTile(context, "Jacob Korsgaard", "Lorem ipsum dolor sit",
                "Yesterday", "assets/avtar2.png"),
            _chatTile(context, "Brandon", "Awesome!! I’ll pick you...",
                "20 July", "assets/avtar2.png"),
            _chatTile(context, "Phillip Carder", "Ullamcorper vulputate",
                "20 July", "assets/avtar2.png",
                isMuted: true),
            _chatTile(context, "Emery Bergson", "Ok. I’ll take care of it.",
                "18 July", "assets/avtar2.png",
                isRead: true),
            _chatTile(context, "Bank", "Your bank statement...", "10 July",
                "assets/bankavtar.png",
                isMuted: true, isUnread: true),
            _chatTile(context, "Brandon Baptista", "Nibh sit malesuada",
                "02 July", "assets/avtar2.png"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble, color: Colors.red), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  static Widget _pinnedCard(String name, String time, String message,
      bool unread, String imagePath) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 16, backgroundImage: AssetImage(imagePath)),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(time, style: const TextStyle(fontSize: 12)),
                if (unread)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.circle, size: 8, color: Colors.blue),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text(message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12))
          ],
        ),
      ),
    );
  }

  static Widget _chatTile(
      BuildContext context,
      String name,
      String message,
      String time,
      String? imagePath, {
        bool isMuted = false,
        bool isRead = false,
        bool isUnread = false,
      }) {
    return InkWell(
      onTap: () {
        if (name == "Jacob Korsgaard") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(userId: "jacob_user_id"),
            ),
          );
        }
      },
      child: ListTile(
        leading: imagePath != null
            ? CircleAvatar(backgroundImage: AssetImage(imagePath))
            : const CircleAvatar(child: Icon(Icons.account_circle_outlined)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontSize: 12)),
            if (isMuted)
              const Icon(Icons.notifications_off, size: 16, color: Colors.grey),
            if (isUnread)
              const Icon(Icons.circle, size: 8, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
