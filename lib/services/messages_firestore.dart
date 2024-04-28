import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get chatRoomsCollection =>
      _firestore.collection('chatRooms');

  Future<void> sendMessage(
    String contactName,
    String receiverId,
    String currentUserId,
    String currentUserName,
    Map<String, dynamic> data,
  ) async {
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await chatRoomsCollection.doc(chatRoomId).set(
      {
        'Usuarios': '$currentUserName - $contactName',
        'ultimaActualizacion': DateTime.now(),
        'ultimoMensaje': data['message'],
      },
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(data);
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
