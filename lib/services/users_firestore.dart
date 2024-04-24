import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener referencia a la colección principal de usuarios
  CollectionReference get usersCollection => _firestore.collection('users');

  Stream<QuerySnapshot> consultar() {
    return usersCollection.snapshots();
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    return usersCollection.doc().set(data);
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) async {
    return usersCollection.doc(id).update(data);
  }

  Future<void> borrar(String id) async {
    return usersCollection.doc(id).delete();
  }

  // Crear subcolección "contactos" para un usuario específico
  Future<void> crearSubcoleccionContactos(String userId,  data) async {
    try {
      // Obtener referencia al documento del usuario
      DocumentReference userDocRef = usersCollection.doc(userId);
      
      // Acceder a la subcolección "contactos" dentro del documento del usuario
      CollectionReference contactosCollection = userDocRef.collection('contactos');

      // Crear un documento en la subcolección
      await contactosCollection.doc().set(data);
    } catch (error) {
      print('Error al crear subcolección de contactos: $error');
    }
  }

  Future<String?> encontrarUserIdPorUid(String uid) async {
    try {
      QuerySnapshot snapshot = await usersCollection.where('uid', isEqualTo: uid).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (error) {
      print('Error al encontrar userId por uid: $error');
      return null;
    }
  }
  Future<QuerySnapshot?> encontrarUsuarioPorEmail(String email) async {
  try {
    QuerySnapshot snapshot = await usersCollection.where('email', isEqualTo: email).get();
    return snapshot; // Devuelve el QuerySnapshot con los datos del usuario
  } catch (error) {
    print('Error al encontrar usuario por email: $error');
    return null;
  }
}
}
