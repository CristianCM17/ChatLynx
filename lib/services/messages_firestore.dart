import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String receiverId, String currentUserId, String message) async {
    final Timestamp timestamp = Timestamp.now();

    Map<String, dynamic> newMessage = {
      "senderId": currentUserId,
      "receiverId": receiverId,
      "message": message,
      "hora": timestamp
    };

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage);
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserid) {
    List<String> ids = [userId, otherUserid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('hora', descending: false)
        .snapshots();
  }
}
