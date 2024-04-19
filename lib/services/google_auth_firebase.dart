import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthFirebase {
  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  // Métodos para información del usuario
  String? getUserDisplayName() {
    return _userCredential?.user?.displayName;
  }

  String? getUserEmail() {
    return _userCredential?.user?.email;
  }

  String? getUserPhotoURL() {
    return _userCredential?.user?.photoURL;
  }

  // LOGIN
  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Inicio de sesión con Google cancelado por el usuario.");
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      _userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (_userCredential?.user != null) {
        return _getUserInfo();
      } else {
        print(
            'No se pudo obtener el usuario después del inicio de sesión con Google.');
        return null;
      }
    } catch (e) {
      print('Error en el inicio de sesión con Google: $e');
      return null;
    }
  }

  // SIGNOUT
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn()
          .signOut(); //Desregistrar totalmente del Google Sign-in
      _userCredential = null;
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error al cerrar sesión: ${e.message}');
      return false;
    } catch (e) {
      print('Error al cerrar sesión: $e');
      return false;
    }
  }

  // Obtener información del usuario
  Map<String, dynamic> _getUserInfo() {
    return {
      'nombre': getUserDisplayName() ?? 'Desconocido',
      'email': getUserEmail() ?? 'Desconocido',
      'photoURL': getUserPhotoURL() ?? '',
    };
  }
}
