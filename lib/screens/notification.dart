import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3;

  late AnimationController _controller;

  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message',
      'subtitle': 'You have a new message from Jacob.',
      'time': '2 mins ago'
    },
    {
      'title': 'Pet Adoption',
      'subtitle': 'Your pet adoption request is approved!',
      'time': '1 hour ago'
    },
    {
      'title': 'Offer Alert',
      'subtitle': 'Special discount on pet accessories.',
      'time': 'Yesterday'
    },
    {
      'title': 'Reminder',
      'subtitle': 'Don’t forget your vet appointment tomorrow.',
      'time': '2 days ago'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 6.28, // full spin
                child: IconButton(
                  icon: const Icon(Icons.notifications_active, color: Colors.red),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(index * 0.15, 1.0, curve: Curves.easeOut),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.red.shade50,
                    child: const Icon(Icons.notifications_active,
                        color: Colors.red),
                  ),
                  title: Text(
                    notif['title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    notif['subtitle']!,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  trailing: Text(
                    notif['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Opening ${notif['title']}..."),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ''),
          ],
        ),
      ),
    );
  }
}
