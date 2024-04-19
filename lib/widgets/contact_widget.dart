import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 52,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 52,
              height: 52,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/52x52"),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31),
                ),
              ),
            ),
          ),
          Positioned(
            left: 64,
            top: 25,
            child: Text(
              'Afrin Sabila ',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 0.06,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
