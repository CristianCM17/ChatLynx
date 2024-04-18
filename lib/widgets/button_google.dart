import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonGoogle extends StatelessWidget {
  const ButtonGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        /* auth_google.loginWithGoogle().then((value) {
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListViewScreen(),
                      ),
                    );
                    var snackbar = SnackBar(
                      content: Text(
                        "Iniciaste Sesión como:\n${auth_google.getUserDisplayName() ?? 'Desconocido'}",
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w500),
                      ),
                      duration: const Duration(seconds: 4),
                      backgroundColor: const Color(0xFF6440FE),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                          bottom: 50, left: 20, right: 20),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                });*/
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
}
