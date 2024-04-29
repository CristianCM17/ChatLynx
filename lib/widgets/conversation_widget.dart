import 'package:chatlynx/screens/conversation_screen.dart';
import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConversationWidget extends StatefulWidget {
  final Map<String, dynamic>? chatRoomdata;

  const ConversationWidget({super.key, this.chatRoomdata});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Timestamp timestamp = widget.chatRoomdata!['ultimaActualizacion'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    String formattedDate;

    if (dateTime.year == now.year && // Verificamos fecha ayer
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      formattedDate = 'Ayer, ${DateFormat('HH:mm a').format(dateTime)}';
    } else if (dateTime.year == now.year && // Si han pasado más de un día
        dateTime.month == now.month &&
        dateTime.day < now.day - 1) {
      formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      formattedDate = DateFormat('HH:mm a').format(dateTime);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ConversationScreen(
                    uid: "",
                    nombre: "",
                    imageURL: "https://via.placeholder.com/52x52",
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      print("Imagen abierta");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ImageViewScreen(
                            nombre: "",
                            imageURL: "https://via.placeholder.com/52x52",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.chatRoomdata!['photoURLReceiver']),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6),
                  alignment: Alignment.topRight,
                  child: Text(
                    formattedDate,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      color: Color(0xFFE6D3B5),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      height: 6,
                    ),
                  ),
                ),
                Positioned(
                  left: 64,
                  top: 9,
                  child: Container(
                    width: size.width,
                    height: 48,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Text(
                            widget.chatRoomdata!["nameReceiver"],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.7,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 26,
                          child: Text(
                            widget.chatRoomdata!['ultimoMensaje'],
                            style: GoogleFonts.poppins(
                              color: Color(0xFFE6D3B5),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
