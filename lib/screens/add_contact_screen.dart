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
                  if (_formKey.currentState!.validate()) {
                    String email = _emailController.text;
                    print('Correo electrónico válido: $email');
                    Navigator.pop(context);
                  }
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
