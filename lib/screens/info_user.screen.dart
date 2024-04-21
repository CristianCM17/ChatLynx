import 'package:chatlynx/services/google_auth_firebase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleAuthFirebase authGoogle = GoogleAuthFirebase();
    var googleListInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/fondo_ws.png"),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Colors.green.shade900, Colors.black],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                          iconSize: 32,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Dialog(
                    surfaceTintColor: Colors.black,
                    shadowColor: Colors.green[400],
                    elevation: 120,
                    backgroundColor: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              "Información de Perfil",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                "Nombre: ${googleListInfo["nombre"]}",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Correo Electrónico: ${googleListInfo["email"]}",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 35),
                              Center(
                                child: Text(
                                  "Imagen",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                      "${googleListInfo["photoURL"]}"),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool signOutSuccess =
                                        await authGoogle.signOutFromGoogle();
                                    if (signOutSuccess) {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          "/welcome", (route) => false);

                                      print("Cierre de sesion exitoso");
                                      var snackbar = SnackBar(
                                        content: Text(
                                          "Cierre de sesión exitoso",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: Colors.green.shade300,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(
                                            bottom: 50, left: 20, right: 20),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    } else {
                                      var snackbar = SnackBar(
                                        content: Text(
                                          "No se pudo cerrar la sesion",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    }
                                  },
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(horizontal: 45)),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.white)),
                                  child: Text(
                                    'Cerrar Sesión',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
