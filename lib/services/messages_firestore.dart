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
    String photoURL,
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
        'photoURLReceiver': photoURL,
        'nameReceiver': contactName,
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

  Stream<DocumentSnapshot> consultarChatRoom(
      String currentUserId, String receiverId) {
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
   

    return chatRoomsCollection.doc(chatRoomId).snapshots();
  }

  Future<List<Map<String,dynamic>>> getChatRoomsForUser(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('chatRooms')
      .get();

    List<Map<String,dynamic>> filteredDocs = [];

    querySnapshot.docs.forEach((doc) {
      List<String> ids = doc.id.split('_');
      if (ids.contains(userId)) {
        Map<String,dynamic> chatRoomdata = {
          "Usuarios" : doc.get("Usuarios"),
          "nameReceiver" : doc.get("nameReceiver"),
          "photoURLReceiver" : doc.get("photoURLReceiver"),
          "ultimaActualizacion": doc.get("ultimaActualizacion"),
          "ultimoMensaje" : doc.get("ultimoMensaje"),
        };
        filteredDocs.add(chatRoomdata);
      }
    });
    print(filteredDocs);
    return filteredDocs;
  }
}
