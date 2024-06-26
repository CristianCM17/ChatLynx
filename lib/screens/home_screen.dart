import 'package:chatlynx/services/google_auth_firebase.dart';
import 'package:chatlynx/services/groups_firestore.dart';
import 'package:chatlynx/services/messages_firestore.dart';
import 'package:chatlynx/services/users_firestore.dart';
import 'package:chatlynx/widgets/groups_widget.dart';
import 'package:chatlynx/widgets/contact_widget.dart';
import 'package:chatlynx/widgets/conversation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GoogleAuthFirebase authGoogle = GoogleAuthFirebase();
  final UsersFirestore usersFirestore = UsersFirestore();
  final MessagesFireStore messagesFirestore = MessagesFireStore();
  final GroupsFirestore groups = GroupsFirestore();

  List<Widget> _buildWidgetOptions(currentUid) {
    return <Widget>[
      //MENSAJES
      buildConversationHistory(currentUid),
      //VIDEOLLAMADAS
      buildGroupList(currentUid),
      //CONTACTOS
      buildConversationStreamBuilder(currentUid), // Movido aquí
    ];
  }

  Widget buildGroupList(currentUid) {
    return StreamBuilder(
        stream: groups.getGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Error al obtener datos");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No tienes grupos aún",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> groupData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  List<dynamic> members = groupData['members'];
                  // Verificamos si es admin
                  if (groupData['admin'] == currentUid ||
                      members.any((member) => member['uid'] == currentUid)) {
                    return GroupsWidget(groupData: snapshot.data!.docs[index]);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            }
          } else {
            return const Text("No hay datos disponibles");
          }
        });
  }

  Widget buildConversationHistory(currentUid) {
    return FutureBuilder(
      future: messagesFirestore.getChatRoomsForUser(currentUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text("Error al obtener datos");
        } else if (snapshot.hasData) {
          List<Map<String, dynamic>> chatRooms = // Obtenemos lista
              snapshot.data as List<Map<String, dynamic>>;
          compareByLastUpdate(a, b) {
            Timestamp timestampA = a['ultimaActualizacion'];
            Timestamp timestampB = b['ultimaActualizacion'];
            DateTime dateTimeA = timestampA.toDate();
            DateTime dateTimeB = timestampB.toDate();
            return dateTimeB.compareTo(dateTimeA);
          }

          //Ordenamos
          chatRooms.sort(compareByLastUpdate);

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ConversationWidget(
                  chatRoomdata: chatRooms[index], currentUid: currentUid);
            },
          );
        } else {
          return const Text("No hay datos disponibles");
        }
      },
    );
  }

  Widget buildConversationStreamBuilder(currentUid) {
    return FutureBuilder(
      future: usersFirestore.encontrarUserIdPorUid(currentUid),
      builder: (BuildContext context, AsyncSnapshot userInfoSnapshot) {
        if (userInfoSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (userInfoSnapshot.hasError) {
          return const Text("Error al obtener información del usuario");
        } else {
          var userId = userInfoSnapshot.data;
          return StreamBuilder(
            stream: usersFirestore.consultarContactos(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text("Error al obtener datos");
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay contactos agregados",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ContactWidget(
                          usersData: snapshot.data!.docs[index]);
                    },
                  );
                }
              } else {
                return const Text("No hay datos disponibles");
              }
            },
          );
        }
      },
    );
  }

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
                        ? "Grupos"
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
                  image: const DecorationImage(image: AssetImage("assets/tecelaya.png"))
                ),
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
              child: _buildWidgetOptions(googleListInfo["uid"])
                  .elementAt(_selectedIndex),
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
              icon: Icon(Icons.groups_2_outlined),
              activeIcon: Icon(Icons.groups_2),
              label: 'Grupos',
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
      //Añadimos btn a zona de contactos
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              backgroundColor: Colors.green[500],
              onPressed: () {
                Navigator.pushNamed(context, "/addContact",
                    arguments: googleListInfo);
              },
              elevation: 4,
              tooltip: 'Agregar contacto nuevo',
              splashColor: Colors.green[300],
              child: const Icon(
                Icons.person_add,
                size: 32,
              ),
            )
          : _selectedIndex == 1
              ? FloatingActionButton(
                  backgroundColor: Colors.green[500],
                  onPressed: () {
                    Navigator.pushNamed(context, "/addGroup",
                        arguments: googleListInfo);
                  },
                  elevation: 4,
                  tooltip: 'Agregar grupo nuevo',
                  splashColor: Colors.green[300],
                  child: const Icon(
                    Icons.library_add,
                    size: 32,
                  ),
                )
              : null,
    );
  }
}
