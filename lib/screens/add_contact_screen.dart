import 'package:chatlynx/services/users_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UsersFirestore usersFirestore = UsersFirestore();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Validamos correo electrónico
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el correo electrónico';
    }
    bool isValidEmail = RegExp(r'^[\w-\.]+@itcelaya\.edu\.mx$').hasMatch(value);
    if (!isValidEmail) {
      return 'Ingresa un email válido con el dominio itcelaya.edu.mx';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var googleData =
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
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.green.shade900],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: AppBar(
              leadingWidth: 75,
              toolbarHeight: 70,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                10, // Posición desde la parte superior
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/tecelaya.png",
                          height: 150,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text(
                          "Agrega un nuevo contacto",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 28),
                        )),
                      ),
                      Center(
                          child: Text(
                        "Conéctate con amigos y profesores del TECNM en Celaya con ChatLynx",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6), fontSize: 18),
                      )),
                      const SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        style: GoogleFonts.poppins(color: Colors.white),
                        controller: _emailController,
                        decoration: InputDecoration(
                            errorStyle:
                                GoogleFonts.poppins(color: Colors.red.shade300),
                            labelStyle:
                                GoogleFonts.poppins(color: Colors.white),
                            labelText: 'Correo electrónico a añadir'),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          usersFirestore.consultar().first.then((snapshot) {
                            bool uidExists = snapshot.docs.any(
                                (doc) => doc['email'] == _emailController.text);
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              if (!uidExists) {
                                var snackbar = SnackBar(
                                  content: Text(
                                    "El email no esta registrado en Chatlynx",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                      bottom: 50, left: 20, right: 20),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                                print(
                                    "El email no esta registrado en Chatlynx");
                              } else {
                                usersFirestore
                                    .encontrarUserIdPorUid(googleData["uid"])
                                    .then((value) async {
                                  var userData = await usersFirestore
                                      .encontrarUsuarioPorEmail(
                                          _emailController.text);
                                  var existeCorreo = await usersFirestore
                                      .existeCorreoEnContactos(
                                          value, _emailController.text);
                                  if (value != null &&
                                      userData!.docs.isNotEmpty &&
                                      !existeCorreo) {
                                    usersFirestore
                                        .crearSubcoleccionContactos(
                                            value, userData.docs.first.data())
                                        .then((_) {
                                      print("Usuario agregado a contactos");
                                      var snackbar = SnackBar(
                                        content: Text(
                                          "Usuario agregado a contactos",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.green.shade300,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(
                                            bottom: 50, left: 20, right: 20),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    var snackbar = SnackBar(
                                      content: Text(
                                        "Ese correo ya lo tienes en tus contactos ${googleData["email"]}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(
                                          bottom: 50, left: 20, right: 20),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                    print(
                                        "Ese correo ya lo tienes en tus contactos ${googleData["email"]}");
                                  }
                                });
                              }
                            }
                          });
                        },
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
                        ),
                        child: Text(
                          'Agregar contacto',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
