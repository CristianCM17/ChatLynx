import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:chatlynx/services/users_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final String imageURL;
  final String nombre;
  final String uid;
  const ConversationScreen(
      {super.key,
      required this.imageURL,
      required this.nombre,
      required this.uid});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final UsersFirestore usersFirestore = UsersFirestore();
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
                    builder: (context) => ImageViewScreen(
                      nombre: widget.nombre,
                      imageURL: widget.imageURL,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.imageURL),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                widget.nombre,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w300),
              ),
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
                child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: usersFirestore.consultarMensajesEntreUsuariosStream(
                  userId, widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error al cargar los mensajes');
                  } else {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> mensaje = snapshot.data![index];
                          //Convertimos fecha
                          Timestamp timestamp = mensaje['fecha'];
                          DateTime dateTime = timestamp.toDate();
                          // String formattedDate =
                          // DateFormat('dd/MM/yyyy HH:mm a').format(dateTime);
                          String formattedDate =
                              DateFormat('HH:mm a').format(dateTime);

                          return ListTile(
                            title: Text(
                              mensaje['contenido'],
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No hay mensajes aún',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            )),

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
                    onPressed: () async {
                      String userIdUser =
                          FirebaseAuth.instance.currentUser!.uid;
                      String? userName =
                          FirebaseAuth.instance.currentUser!.displayName;
                      String message = _messageController.text;
                      String contactoId = widget.uid; // ID de contact

                      print('Mensaje enviado: $message');
                      _messageController.clear();

                      // Creacion de msj
                      Map<String, dynamic> data = {
                        'contenido': message,
                        'fecha': DateTime.now(),
                      };

                      //ID usuario actual en BD
                      String? userIdDB = await usersFirestore
                          .encontrarUserIdPorUid(userIdUser);
                      if (userIdDB != null) {
                        // ID contact desde subcolección contactos
                        String? contactoIdDB = await usersFirestore
                            .encontrarUserIdPorUid(contactoId);
                        if (contactoIdDB != null) {
                          // Llamamos método para crear la subcolección
                          usersFirestore.crearSubcoleccionMensajes(
                              userIdDB,
                              widget.uid,
                              widget.nombre,
                              data,
                              userIdUser,
                              userName!);
                        } else {
                          print(
                              'No se encontró el ID del contacto en la base de datos.');
                        }
                      } else {
                        print(
                            'No se encontró el ID del usuario actual en la base de datos.');
                      }
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
