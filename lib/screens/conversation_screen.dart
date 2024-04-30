import 'dart:io';
import 'dart:ui';
import 'dart:async';
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
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
  final MessagesFireStore messagesFireStore = MessagesFireStore();
  String userId = FirebaseAuth.instance.currentUser!.uid;
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

      Map<String, dynamic> data = {
        'message': imageUrl,
        'hora': DateTime.now(),
        'receiverId': widget.uid,
        'senderId': userId,
        'type': 'image',
      };
      await messagesFireStore.sendMessage(
        widget.nombre,
        widget.uid,
        userId,
        FirebaseAuth.instance.currentUser!.displayName!,
        widget.imageURL,
        FirebaseAuth.instance.currentUser!.photoURL!,
        data,
      );
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

      Map<String, dynamic> data = {
        'message': imageUrl,
        'hora': DateTime.now(),
        'receiverId': widget.uid,
        'senderId': userId,
        'type': 'image',
      };
      await messagesFireStore.sendMessage(
        widget.nombre,
        widget.uid,
        userId,
        FirebaseAuth.instance.currentUser!.displayName!,
        widget.imageURL,
        FirebaseAuth.instance.currentUser!.photoURL!,
        data,
      );
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

      Map<String, dynamic> data = {
        'message': videoUrl,
        'hora': DateTime.now(),
        'receiverId': widget.uid,
        'senderId': userId,
        'type': 'video',
      };
      await messagesFireStore.sendMessage(
        widget.nombre,
        widget.uid,
        userId,
        FirebaseAuth.instance.currentUser!.displayName!,
        widget.imageURL,
        FirebaseAuth.instance.currentUser!.photoURL!,
        data,
      );
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

      Map<String, dynamic> data = {
        'message': videoUrl,
        'hora': DateTime.now(),
        'receiverId': widget.uid,
        'senderId': userId,
        'type': 'video',
      };
      await messagesFireStore.sendMessage(
        widget.nombre,
        widget.uid,
        userId,
        FirebaseAuth.instance.currentUser!.displayName!,
        widget.imageURL,
        FirebaseAuth.instance.currentUser!.photoURL!,
        data,
      );
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

      Map<String, dynamic> data = {
        'message': uploadedGifUrl,
        'hora': DateTime.now(),
        'receiverId': widget.uid,
        'senderId': userId,
        'type': 'gif',
      };
      await messagesFireStore.sendMessage(
        widget.nombre,
        widget.uid,
        userId,
        FirebaseAuth.instance.currentUser!.displayName!,
        widget.imageURL,
        FirebaseAuth.instance.currentUser!.photoURL!,
        data,
      );

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
          if (userId != widget.uid) //Si no estas en tu mismo chat
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
                child: StreamBuilder(
              stream: messagesFireStore.getMessages(userId, widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return const Text('Error al cargar los mensajes');
                  } else {
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
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
                    } else {
                      Future.delayed(Duration(microseconds: 0)).then((_) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var mensaje = snapshot.data!.docs[index];
                          String senderId = mensaje['senderId'];
                          bool isCurrentUser = senderId == userId;

                          //Convertimos fecha
                          Timestamp timestamp = mensaje['hora'];
                          DateTime dateTime = timestamp.toDate();
                          DateTime now = DateTime.now();
                          String formattedDate;
                          if (dateTime.year ==
                                  now.year && // Verificamos fecha ayer
                              dateTime.month == now.month &&
                              dateTime.day == now.day - 1) {
                            formattedDate =
                                'Ayer, ${DateFormat('HH:mm a').format(dateTime)}';
                          } else if (dateTime.year ==
                                  now.year && // Si han pasado más de un día
                              dateTime.month == now.month &&
                              dateTime.day < now.day - 1) {
                            formattedDate =
                                DateFormat('dd/MM/yyyy').format(dateTime);
                          } else {
                            formattedDate =
                                DateFormat('HH:mm a').format(dateTime);
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            child: Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                //Para cuando el msj es muy largo
                                constraints: BoxConstraints(
                                  maxWidth: size.width * 0.75,
                                ),
                                child: IntrinsicWidth(
                                  //Ajuste al msj dinamicamente
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? Colors.grey.shade800
                                          : const Color.fromRGBO(
                                              242, 247, 251, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            isCurrentUser ? 16.0 : 0.0),
                                        topRight: Radius.circular(16.0),
                                        bottomLeft: Radius.circular(16.0),
                                        bottomRight: Radius.circular(
                                            isCurrentUser ? 0.0 : 16.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (mensaje['type'] == 'image')
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageViewScreen(
                                                    imageURL:
                                                        mensaje['message'],
                                                    nombre: "",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.network(
                                              mensaje['message'],
                                              width: 200,
                                              height: 200,
                                            ),
                                          ),
                                        if (mensaje['type'] == 'video')
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 8),
                                            child: Align(
                                              alignment: isCurrentUser
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: SizedBox(
                                                width: size.width * 0.75,
                                                height: 200,
                                                child: VideoPlayerScreen(
                                                    videoUrl:
                                                        mensaje['message']),
                                              ),
                                            ),
                                          ),
                                        if (mensaje['type'] == 'gif')
                                          Image.network(
                                            mensaje['message'],
                                            width: 200,
                                            height: 200,
                                          ),
                                        if (mensaje['type'] != 'image' &&
                                            mensaje['type'] != 'video' &&
                                            mensaje['type'] != 'gif')
                                          SelectableText(
                                            mensaje[
                                                'message'], // El texto del mensaje
                                            style: GoogleFonts.poppins(
                                              color: isCurrentUser
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                            // const SizedBox(width: 4.0),
                                            // const Icon(
                                            //   Icons.done_all,
                                            //   color: Colors.blue,
                                            //   size: 16.0,
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                }
              },
            )),

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
                      String userIdContact = widget.uid;
                      String nameContact = widget.nombre;
                      String photoURLContact = widget.imageURL;
                      String? userName =
                          FirebaseAuth.instance.currentUser!.displayName;
                      String? photoURLSender =
                          FirebaseAuth.instance.currentUser!.photoURL;
                      String message = _messageController.text;

                      // Creacion de msj
                      if (message.trim().isNotEmpty) {
                        Map<String, dynamic> data = {
                          'message': message,
                          'hora': DateTime.now(),
                          'receiverId': userIdContact,
                          'senderId': userId,
                          'type': 'text'
                        };

                        await messagesFireStore.sendMessage(
                            nameContact,
                            userIdContact,
                            userId,
                            userName!,
                            photoURLContact,
                            photoURLSender!,
                            data);

                        print("Mensaje enviado ${message}");
                        _messageController.clear();
                      } else {
                        print("No vacios");
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
