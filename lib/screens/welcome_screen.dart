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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.black],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 60),
                width: MediaQuery.of(context).size.width * .8,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Conecta\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Linces\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Facil ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '&\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Rapido',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .8,
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Nuestro chat app es el camino perfecto para estar conectados como comunidad estudiantil.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              ButtonGoogle(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: GestureDetector(
                  onTap: (){
                    
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Existing account? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0.07,
                            letterSpacing: 0.10,
                          ),
                        ),
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0.07,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
