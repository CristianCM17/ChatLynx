import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uidUser = FirebaseAuth.instance.currentUser!.uid;
  String? nameUser = FirebaseAuth.instance.currentUser!.displayName;

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
  Future<void> crearSubcoleccionContactos(String userId, data) async {
    try {
      // Obtener referencia al documento del usuario
      DocumentReference userDocRef = usersCollection.doc(userId);

      // Acceder a la subcolección "contactos" dentro del documento del usuario
      CollectionReference contactosCollection =
          userDocRef.collection('contactos');

      // Crear un documento en la subcolección
      await contactosCollection.doc().set(data);
    } catch (error) {
      print('Error al crear subcolección de contactos: $error');
    }
  }

  Future<String?> encontrarUserIdPorUid(String uid) async {
    try {
      QuerySnapshot snapshot =
          await usersCollection.where('uid', isEqualTo: uid).get();
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
      QuerySnapshot snapshot =
          await usersCollection.where('email', isEqualTo: email).get();
      return snapshot; // Devuelve el QuerySnapshot con los datos del usuario
    } catch (error) {
      print('Error al encontrar usuario por email: $error');
      return null;
    }
  }

  Future<bool> existeCorreoEnContactos(String? userId, String email) async {
    try {
      // Obtener referencia a la subcolección "contactos" dentro del documento del usuario
      CollectionReference contactosCollection =
          usersCollection.doc(userId).collection('contactos');

      // Realizar una consulta para verificar si existe un documento con el correo dado
      QuerySnapshot snapshot =
          await contactosCollection.where('email', isEqualTo: email).get();

      // Si la consulta devuelve al menos un documento, el correo existe en la subcolección
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error al verificar si el correo existe en contactos: $error');
      return false;
    }
  }

  Stream<QuerySnapshot> consultarContactos(String userId) {
    CollectionReference contactosCollection =
        usersCollection.doc(userId).collection('contactos');
    return contactosCollection.snapshots();
  }

  Future<void> crearSubcoleccionMensajes(
    String userId,
    String contactoId,
    String contactoName,
    Map<String, dynamic> data,
  ) async {
    try {
      // Referencia
      DocumentReference userDocRef = usersCollection.doc(userId);
      // Accedemos a collection msjs dentro de doc usuario
      CollectionReference mensajesCollection =
          userDocRef.collection('mensajes');
      // Generamos name de doc
      // String nombreDocumento = '$contactoId-$contactoName';

      // Accedemos a subcollection dentro de coleccion mensajes
      CollectionReference listaMensajesCollection =
          mensajesCollection.doc(contactoId).collection('listamensajes');
      // Nuevo doc a subcollection
      await listaMensajesCollection.doc().set(data);

      // Actualizamos collection con info
      await mensajesCollection.doc(contactoId).set(
        {
          'uid_remitente': uidUser,
          'nombre_remitente': nameUser,
          'nombre_destino': contactoName,
          'uid_destino': contactoId,
          'ultimaActualizacion': DateTime.now(),
          'ultimoMensaje': data['contenido'],
        },
        // Merge en true mezclar datos (Nuevos y Existentes)
        SetOptions(merge: true),
      );
    } catch (error) {
      print('Error al crear subcolección de mensajes: $error');
    }
  }
}
