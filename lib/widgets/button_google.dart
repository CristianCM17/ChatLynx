import 'package:flutter/material.dart';
import 'package:chatlynx/services/google_auth_firebase.dart';
import 'package:chatlynx/services/users_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonGoogle extends StatefulWidget {
  const ButtonGoogle({super.key});

  @override
  State<ButtonGoogle> createState() => _ButtonGoogleState();
}

class _ButtonGoogleState extends State<ButtonGoogle> {
  final GoogleAuthFirebase authGoogle = GoogleAuthFirebase();
  final UsersFirestore usersFirestore = UsersFirestore();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        authGoogle.loginWithGoogle(context).then((userInfo) {
          if (userInfo != null) {
            usersFirestore.consultar().first.then((snapshot) {
              bool uidExists =
                  snapshot.docs.any((doc) => doc['uid'] == userInfo['uid']);
              if (!uidExists) {
                usersFirestore.insertar({
                  'uid': userInfo['uid'],
                  'nombre': userInfo['nombre'],
                  'email': userInfo['email'],
                  'photoURL': userInfo['photoURL'],
                }).then((_) {
                  Navigator.pushNamed(context, "/home", arguments: userInfo);
                  showLoginSnackBar(context, userInfo);
                });
              } else {
                print(
                    'El UID ${userInfo['uid']} ya existe en la colección "users".');
                Navigator.pushNamed(context, "/home", arguments: userInfo);
                showLoginSnackBar(context, userInfo);
              }
            });
          } else {
            print('Inicio de sesión con Google fallido');
          }
        });
      },
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: const CircleBorder(),
              ),
              child: Image.asset("assets/g_logo.png")),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Google",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void showLoginSnackBar(BuildContext context, Map<String, dynamic> userInfo) {
    var snackbar = SnackBar(
      content: Text(
        "Iniciaste Sesión como: ${userInfo['nombre'] ?? 'Desconocido'}",
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade300,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
