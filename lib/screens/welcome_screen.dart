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
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
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
            SizedBox(height: size.height * 0.07),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * .8,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Conecta Linces Fácil & Rápido',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: size.width * 0.165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Nuestro chat app es el camino perfecto para estar conectados como comunidad estudiantil.',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/divider.png",
                ),
                SizedBox(width: size.width * 0.07),
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
                SizedBox(width: size.width * 0.07),
                Image.asset(
                  "assets/divider.png",
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.02),
              child: ButtonGoogle(),
            ),
          ],
        ),
      ),
    ));
  }
}
