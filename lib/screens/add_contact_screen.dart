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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar contacto',
          style: GoogleFonts.poppins(),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.black.withOpacity(0.90),
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                validator: _validateEmail,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  usersFirestore.consultar().first.then((snapshot) {
                    bool uidExists = snapshot.docs
                        .any((doc) => doc['email'] == _emailController.text);
                    if (_formKey.currentState!.validate()) {
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
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      print("El email no esta registrado en Chatlynx");
                    } else {
                      var snackbar = SnackBar(
                        content: Text(
                          "Usuario agregado a contactos",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.green.shade300,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            bottom: 50, left: 20, right: 20),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.pop(context);
                      print("Usuario agregado a contactos");
                    }
                    }
                    
                  });
                },
                child: Text('Agregar contacto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
