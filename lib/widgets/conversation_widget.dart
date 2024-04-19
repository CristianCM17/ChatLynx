import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConversationWidget extends StatefulWidget {
  const ConversationWidget({super.key});

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            margin: EdgeInsets.only(top: 6),
            alignment: Alignment.topRight,
            child: Text(
              '2 min ago',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFE6D3B5),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                height: 0.08,
              ),
            ),
          ),
          Positioned(
            left: 64,
            top: 9,
            child: Container(
              width: 144,
              height: 38,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      'Alex Linderson',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.05,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 26,
                    child: Text(
                      'How are you today?',
                      style: TextStyle(
                        color: Color(0xFFE6D3B5),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
