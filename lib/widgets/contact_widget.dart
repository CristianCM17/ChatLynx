import 'package:chatlynx/screens/conversation_screen.dart';
import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactWidget extends StatefulWidget {
  final QueryDocumentSnapshot? usersData;

  const ContactWidget({super.key, this.usersData});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    nombre: widget.usersData!.get("nombre"),
                    imageURL: widget.usersData!.get("photoURL"),
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            width: size.width,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewScreen(
                            nombre: widget.usersData!.get("nombre"),
                            imageURL: widget.usersData!.get("photoURL"),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image:
                              NetworkImage(widget.usersData!.get("photoURL")),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 64,
                  top: 25,
                  child: Text(
                    widget.usersData!.get("nombre"),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 0.06,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
