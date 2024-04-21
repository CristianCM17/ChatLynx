import 'package:chatlynx/screens/conversation_screen.dart';
import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationWidget extends StatefulWidget {
  const ConversationWidget({super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConversationScreen()),
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
                          image:
                              NetworkImage("https://via.placeholder.com/52x52"),
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
                    '2 min ago',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      color: Color(0xFFE6D3B5),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      height: 2.5,
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
                            'Alex Linderson',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 0.85,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 26,
                          child: Text(
                            'How are you today?',
                            style: GoogleFonts.poppins(
                              color: Color(0xFFE6D3B5),
                              fontSize: 12,
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
