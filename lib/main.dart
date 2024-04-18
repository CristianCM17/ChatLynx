import 'package:chatlynx/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //integracion con firebase
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyDi4PKYKwpSLtfrpV5nPgTd_p0fs_VDPu0", // paste your api key here
      appId:
          "com.example.chatlynx", //paste your app id here
      messagingSenderId: "843525052315", //paste your messagingSenderId here
      projectId: "chat-82a68", //paste your project id here
    ),
  );

  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
