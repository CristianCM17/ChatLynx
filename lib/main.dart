import 'package:chatlynx/screens/add_contact_screen.dart';
import 'package:chatlynx/screens/add_group_screen.dart';
import 'package:chatlynx/screens/call_screen.dart';
import 'package:chatlynx/screens/conversation_screen.dart';
import 'package:chatlynx/screens/home_screen.dart';
import 'package:chatlynx/screens/image_view_screen.dart';
import 'package:chatlynx/screens/info_user.screen.dart';
import 'package:chatlynx/screens/search_conversation_screen.dart';
import 'package:chatlynx/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //integracion con firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDi4PKYKwpSLtfrpV5nPgTd_p0fs_VDPu0",
      appId: "com.example.chatlynx",
      messagingSenderId: "843525052315",
      projectId: "chat-82a68",
      storageBucket: "chat-82a68.appspot.com",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        "/welcome": (BuildContext context) => const WelcomeScreen(),
        "/home": (BuildContext context) => const HomePage(),
        "/infoUser": (BuildContext context) => const InfoUser(),
        "/searchConversation": (BuildContext context) =>
            const SearchConversation(),
        "/addContact": (BuildContext context) => const AddContactScreen(),
        "/addGroup": (BuildContext context) => const AddGroupScreen(),
        "/videoCall": (BuildContext context) => const CallScreen(),
      },
    );
  }
}
