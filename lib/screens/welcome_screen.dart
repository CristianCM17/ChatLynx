import 'package:chatlynx/widgets/button_google.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/fondo_ws.png"),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade900, Colors.black.withOpacity(0.9)],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
            width: MediaQuery.of(context).size.width * .8,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Conecta Linces Fácil & Rápido',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 68,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text(
              'Nuestro chat app es el camino perfecto para estar conectados como comunidad estudiantil.',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/divider.png",
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                'INICIA SESIÓN',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 0.07,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Image.asset(
                "assets/divider.png",
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const ButtonGoogle(),
        ],
      ),
    ));
  }
}
