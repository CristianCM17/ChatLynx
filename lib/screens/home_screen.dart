import 'package:chatlynx/services/google_auth_firebase.dart';
import 'package:chatlynx/widgets/calls_widget.dart';
import 'package:chatlynx/widgets/contact_widget.dart';
import 'package:chatlynx/widgets/conversation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GoogleAuthFirebase authGoogle = GoogleAuthFirebase();

  static const List<Widget> _widgetOptions = <Widget>[
    //MENSAJES
    SingleChildScrollView(
      child: Column(
        children: [
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
          ConversationWidget(),
        ],
      ),
    ),
    //VIDEOLLAMADAS
    SingleChildScrollView(
      child: Column(
        children: [
          CallsWidget(),
          CallsWidget(),
          CallsWidget(),
          CallsWidget(),
          CallsWidget(),
          CallsWidget(),
        ],
      ),
    ),
    //CONTACTOS
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget(),
          ContactWidget()
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var googleListInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/fondo_ws.png"),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade900, Colors.black.withOpacity(1)],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: AppBar(
              leadingWidth: 75,
              toolbarHeight: 70,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Text(
                _selectedIndex == 0
                    ? "ChatLynx"
                    : _selectedIndex == 1
                        ? "Videollamadas"
                        : "Contactos",
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.w300),
              ),
              centerTitle: true,
              leading: Container(
                margin: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/searchConversation");
                    }),
              ),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    authGoogle.loginWithGoogle(context).then((userInfo) {
                      Navigator.pushNamed(context, "/infoUser",
                          arguments: userInfo);
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage("${googleListInfo["photoURL"]}"),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                20, // Posición desde la parte superior
            left: 0,
            right: 0,
            bottom: 0, // Ocupará todo el espacio disponible debajo del AppBar
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 85, //Altura del bottomNav
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message_rounded),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_camera_front_outlined),
              activeIcon: Icon(Icons.video_camera_front),
              label: 'Videollamadas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
              activeIcon: Icon(Icons.contacts),
              label: 'Contactos',
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 0,
          selectedItemColor: Colors.green.shade500,
          backgroundColor: Colors.black,
          iconSize: 32,
          unselectedItemColor: Colors.white,
          unselectedLabelStyle:
              GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          selectedLabelStyle:
              GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      //Añadimos btn a zona de contactos
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              backgroundColor: Colors.green[500],
              onPressed: () {},
              child: Icon(
                Icons.person_add,
                size: 32,
              ),
              elevation: 4,
              tooltip: 'Agregar contacto nuevo',
              splashColor: Colors.green[300],
            )
          : null,
    );
  }
}
