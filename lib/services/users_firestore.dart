
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirestore {

  final fireStore = FirebaseFirestore.instance; 
  CollectionReference? _usersCollection;

  UsersFirestore() {
    _usersCollection = fireStore.collection('users');
  }

  Stream<QuerySnapshot> consultar() {
    return _usersCollection!.snapshots(); //Obtenemos los resultados de la BD
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    return _usersCollection!.doc().set(data);
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) async {
    return _usersCollection!.doc(id).update(data);
  }

  Future<void> borrar(String id) async {
    _usersCollection!.doc(id).delete();
  }
}