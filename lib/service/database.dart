import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, String senderId, String message) async {
    try {
      await _db.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> createChatIfNotExists(String chatId, List<String> userIds) async {
    final doc = await _db.collection('chats').doc(chatId).get();
    if (!doc.exists) {
      await _db.collection('chats').doc(chatId).set({
        'users': userIds,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
