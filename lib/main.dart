

import 'package:earnilyapp/onbording.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home: onbording(),
 
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String data = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 238, 248),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
     
          SizedBox(
            height: 24,
          ),
           ],
      ),
    );
  }
}
