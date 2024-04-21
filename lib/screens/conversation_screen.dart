import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.90),
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          children: [
            GestureDetector(
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
              child: const CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage("https://via.placeholder.com/52x52"),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'Nombre',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.videocam_outlined),
              iconSize: 32,
              tooltip: 'Realizar Videollamada',
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/fondo_ws.png"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Detalle de la conversación',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),

            //MENU PARA MENSAJE
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines:
                                  null, //Eliminamos que el msj sea en 1 sola linea
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Mensaje',
                                hintStyle: GoogleFonts.poppins(),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file_rounded),
                                onPressed: () {
                                  showMenu(
                                    //Menu de multimedia
                                    context: context,
                                    position: const RelativeRect.fromLTRB(
                                        110, 680, 80, 0),
                                    items: [
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.video_camera_back_rounded),
                                          title: Text('Vídeo'),
                                          titleTextStyle: GoogleFonts.poppins(
                                              color: Colors.black),
                                          onTap: () {
                                            print('Añadir vídeo');
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          leading:
                                              const Icon(Icons.gif_box_rounded),
                                          title: Text('GIF'),
                                          titleTextStyle: GoogleFonts.poppins(
                                              color: Colors.black),
                                          onTap: () {
                                            print('Añadir gif');
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      // Agrega más opciones según sea necesario
                                    ],
                                    elevation: 8,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  print("Enviar imagen");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () {
                      String message = _messageController.text;
                      print('Mensaje enviado: $message');
                      _messageController.clear();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                      iconColor: MaterialStatePropertyAll(Colors.black),
                      padding: MaterialStatePropertyAll(EdgeInsets.all(13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
