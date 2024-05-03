import 'dart:io';

import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:chatlynx/screens/video_player_screen.dart';
import 'package:chatlynx/services/messages_firestore.dart';
import 'package:chatlynx/services/users_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ConversationGroupsScreen extends StatefulWidget {
  const ConversationGroupsScreen({super.key});

  @override
  State<ConversationGroupsScreen> createState() =>
      _ConversationGroupsScreenState();
}

class _ConversationGroupsScreenState extends State<ConversationGroupsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final UsersFirestore usersFirestore = UsersFirestore();
  final MessagesFireStore messagesFireStore = MessagesFireStore();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? nameCurrent = FirebaseAuth.instance.currentUser!.displayName;
  final ScrollController _scrollController = ScrollController();

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      // Subimos a almacenamiento de Storage
      Reference ref =
          FirebaseStorage.instanceFor(bucket: "gs://chat-82a68.appspot.com")
              .ref()
              .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => null);
      // Obtenemos URL
      String imageUrl = await ref.getDownloadURL();
      print('URL de la imagen subida: $imageUrl');

      _messageController.clear();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      // Subimos a almacenamiento de Storage
      Reference ref =
          FirebaseStorage.instanceFor(bucket: "gs://chat-82a68.appspot.com")
              .ref()
              .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => null);
      // Obtenemos URL
      String imageUrl = await ref.getDownloadURL();
      print('URL de la imagen subida: $imageUrl');

      _messageController.clear();
    }
  }

  Future<void> _pickVideoFromGallery() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      File videoFile = File(pickedVideo.path);

      // Subimos el video almacenamiento de  Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      UploadTask uploadTask = ref.putFile(videoFile);
      await uploadTask.whenComplete(() => null);

      String videoUrl = await ref.getDownloadURL();
      print('URL del video subido: $videoUrl');

      _messageController.clear();
    }
  }

  Future<void> _pickVideoFromCamera() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.camera);

    if (pickedVideo != null) {
      File videoFile = File(pickedVideo.path);

      // Subimos el video almacenamiento de  Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      UploadTask uploadTask = ref.putFile(videoFile);
      await uploadTask.whenComplete(() => null);

      String videoUrl = await ref.getDownloadURL();
      print('URL del video subido: $videoUrl');

      _messageController.clear();
    }
  }

  Future<void> _pickGif() async {
    final GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      apiKey: 'ENrCgT8Nc7Jgjgkro9QIDbSJQrYnZZW5',
    );

    if (gif != null) {
      final gifUrl = gif.images!.original!.url; // GIF como archivo
      final response = await http.get(Uri.parse(gifUrl)); // Descargamos GIF
      final directory = await getTemporaryDirectory(); //Ruta temporal
      final gifFile = File('${directory.path}/temp.gif');
      await gifFile.writeAsBytes(response.bodyBytes);

      // Subir gif a firebase
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('gifs/${DateTime.now().millisecondsSinceEpoch}.gif');
      UploadTask uploadTask = ref.putFile(gifFile);
      await uploadTask.whenComplete(() => null);

      final uploadedGifUrl = await ref.getDownloadURL();

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.90),
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewScreen(
                      nombre: '',
                      imageURL:
                          'https://t4.ftcdn.net/jpg/03/78/40/51/360_F_378405187_PyVLw51NVo3KltNlhUOpKfULdkUOUn7j.jpg',
                    ),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://t4.ftcdn.net/jpg/03/78/40/51/360_F_378405187_PyVLw51NVo3KltNlhUOpKfULdkUOUn7j.jpg'),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                "Nombre de group",
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            color: Colors.grey[700],
            onSelected: (String value) {
              if (value == 'ver_miembros') {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      child: ListView.builder(
                        // itemCount: _miembros.length,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return ListTile(
                            // title: Text(_miembros[index]),
                            title: Text('Miembro'),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'ver_miembros',
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Ver miembros',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
              //
            ],
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
              "Mensajes de grupo",
              style: GoogleFonts.poppins(color: Colors.white),
            ))),
            //MENU PARA MENSAJE
            Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 15, top: 5),
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
                                          title: const Text('Vídeo'),
                                          titleTextStyle: GoogleFonts.poppins(
                                              color: Colors.black),
                                          onTap: () {
                                            print('Añadir vídeo');
                                            Navigator.pop(context);
                                            showVideoOptions();
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
                                            _pickGif();
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
                                icon: const Icon(Icons.camera),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.camera_alt),
                                              title: Text(
                                                'Tomar foto',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromCamera();
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.image),
                                              title: Text(
                                                'Seleccionar de galería',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromGallery();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
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
                      String? userName =
                          FirebaseAuth.instance.currentUser!.displayName;
                      String? photoURLSender =
                          FirebaseAuth.instance.currentUser!.photoURL;
                      String message = _messageController.text;

                      print("Mensaje enviado ${message}");
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

  void showVideoOptions() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(
              "Seleccionar fuente de vídeo",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.video_call_rounded,
                    size: 32,
                  ),
                  title: const Text('De cámara'),
                  titleTextStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideoFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.video_camera_back_rounded,
                    size: 28,
                  ),
                  title: const Text('De galería'),
                  titleTextStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideoFromGallery();
                  },
                ),
              ],
            ),
          );
        }));
  }
}
