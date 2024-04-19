import 'package:chatlynx/services/google_auth_firebase.dart';
import 'package:flutter/material.dart';
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
    Text(
      'Placeholder para la página de mensajes',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
    Text(
      'Placeholder para la página de llamadas',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
    Text(
      'Placeholder para la página de contactos',
      style: TextStyle(fontSize: 24, color: Colors.white),
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
                        ? "Llamadas"
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
                    icon: Icon(
                      Icons.search,
                      size: 32,
                    ),
                    onPressed: () {}),
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
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 85, //Altura del bottomNav
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_outlined),
              label: 'Llamadas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
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
    );
  }
}
