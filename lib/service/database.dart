import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Generate a consistent chat ID by sorting both user IDs
  String getChatId(String userA, String userB) {
    final sorted = [userA, userB]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Create the chat document if it doesn't already exist
  Future<void> createChatIfNotExists(String userA, String userB) async {
    final chatId = getChatId(userA, userB);
    final docRef = _db.collection('chats').doc(chatId);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'users': [userA, userB],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
      });
    }
  }

  /// Send a message (only one copy saved)
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = getChatId(senderId, receiverId);
    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('chats').doc(chatId).collection('messages').add(messageData);

      // Optionally update lastMessage preview
      await _db.collection('chats').doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  /// Stream messages for a chat between two users
  Stream<QuerySnapshot> getMessages(String userA, String userB) {
    final chatId = getChatId(userA, userB);
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
