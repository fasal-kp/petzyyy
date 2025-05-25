import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
            const Text('Pinned', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _pinnedCard(
                  name: "Abram",
                  time: "Yesterday",
                  message: "I would like your consent on upcoming meeting...",
                  unread: false,
                  imagePath: "assets/Avatars.png",
                ),
                const SizedBox(width: 12),
                _pinnedCard(
                  name: "Ruben",
                  time: "3:39 pm",
                  message: "You have not been up for tennis match? Are you OK?",
                  unread: true,
                  imagePath: "assets/Avatars.png",
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Recent', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _chatTile(
              context,
              name: "Jacob Korsgaard",
              message: "Lorem ipsum dolor sit",
              time: "Yesterday",
              imagePath: "assets/avtar2.png",
              userId: "jacob_user_id", // replace with real UID from Firestore
            ),
            _chatTile(
              context,
              name: "Brandon",
              message: "Awesome!! I’ll pick you...",
              time: "20 July",
              imagePath: "assets/avtar2.png",
            ),
            _chatTile(
              context,
              name: "Phillip Carder",
              message: "Ullamcorper vulputate",
              time: "20 July",
              imagePath: "assets/avtar2.png",
              isMuted: true,
            ),
            _chatTile(
              context,
              name: "Emery Bergson",
              message: "Ok. I’ll take care of it.",
              time: "18 July",
              imagePath: "assets/avtar2.png",
              isRead: true,
            ),
            _chatTile(
              context,
              name: "Bank",
              message: "Your bank statement...",
              time: "10 July",
              imagePath: "assets/bankavtar.png",
              isMuted: true,
              isUnread: true,
            ),
            _chatTile(
              context,
              name: "Brandon Baptista",
              message: "Nibh sit malesuada",
              time: "02 July",
              imagePath: "assets/avtar2.png",
            ),
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  static Widget _pinnedCard({
    required String name,
    required String time,
    required String message,
    required bool unread,
    required String imagePath,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
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
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chatTile(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required String imagePath,
    String? userId,
    bool isMuted = false,
    bool isRead = false,
    bool isUnread = false,
  }) {
    return InkWell(
      onTap: () {
        if (userId != null) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  currentUserId: currentUser.uid,
                  otherUserId: userId,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are not logged in')),
            );
          }
        }
      },
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
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
