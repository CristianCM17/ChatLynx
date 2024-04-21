import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchConversation extends StatefulWidget {
  const SearchConversation({super.key});

  @override
  State<SearchConversation> createState() => _SearchConversationState();
}

class _SearchConversationState extends State<SearchConversation> {
  final TextEditingController _searchController = TextEditingController();

  //Se obtendrian los chats del perfil
  final List<String> _chats = [
    "Chat 1",
    "Chat 2",
    "Chat 3",
    "Chat 4",
    "Chat 5",
    "Chat 6",
    "Chat 7",
    "Chat 8",
    "Chat 9",
    "Chat 10",
  ];

  List<String> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = _chats;
  }

//Metodo de busqueda contemplando mayus o minus
  void _searchChats(String query) {
    setState(() {
      _filteredChats = _chats
          .where((chat) => chat.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/fondo_ws.png"),
                    fit: BoxFit.cover),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade900, Colors.black])),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: AppBar(
              leadingWidth: 65,
              toolbarHeight: 76,
              backgroundColor: Colors.black.withOpacity(0.9),
              foregroundColor: Colors.white,
              leading: Container(
                margin: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  iconSize: 32,
                ),
              ),
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _searchController,
                    onChanged: _searchChats,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(color: Colors.black),
                      hintText: "Buscar chats...",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        iconSize: 32,
                        color: Colors.black,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchChats("");
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: ListView.builder(
                itemCount: _filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = _filteredChats[index];
                  return ListTile(
                    title: Text(
                      chat,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    onTap: () {
                      //Abrir chat
                      print("Chat seleccionado: $chat");
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
