import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CallsWidget extends StatefulWidget {
  const CallsWidget({Key? key}) : super(key: key);

  @override
  State<CallsWidget> createState() => _CallsWidgetState();
}

class _CallsWidgetState extends State<CallsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    image: const DecorationImage(
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
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    print("Llamando");
                  },
                  child: const Icon(
                    Icons.video_call_rounded,
                    color: Color(0xFFE6D3B5),
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                left: 64,
                top: 9,
                child: Container(
                  width: 144,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          'Jhon Abraham',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 0.05,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 26,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_callback_outlined,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Hoy, 07:30 AM',
                              style: GoogleFonts.poppins(
                                color: Color(0xFFE6D3B5),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20), // Espacio entre los widgets
        Container(
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
                    image: const DecorationImage(
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
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    print("Llamada saliente");
                  },
                  child: const Icon(
                    Icons.video_call_rounded,
                    color: Color(0xFFE6D3B5),
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                left: 64,
                top: 9,
                child: Container(
                  width: 144,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          'Sabila Sayma',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 0.05,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 26,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_forwarded_outlined,
                              color: Colors.greenAccent,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '03/07/2024, 09:35 AM',
                              style: GoogleFonts.poppins(
                                color: Color(0xFFE6D3B5),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
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
    );
  }
}
