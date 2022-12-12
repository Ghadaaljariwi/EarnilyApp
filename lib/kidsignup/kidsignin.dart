// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace
import 'package:earnilyapp/pages/home_page_kid.dart';

import 'package:earnilyapp/widgets/new_button.dart';
import 'package:earnilyapp/widgets/new_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reuasblewidgets.dart';

class kidSignInScreen extends StatefulWidget {
  const kidSignInScreen({super.key});

  @override
  State<kidSignInScreen> createState() => _kidSignInScreenState();
}

class _kidSignInScreenState extends State<kidSignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "حقول الادخال مفقودة",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              " تأكد من ادخال جميع البيانات من فضلك",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text(
                  "حسناً",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var ui;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        backgroundColor: Colors.black,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.01, 20, 0),
                child: Column(
                  children: <Widget>[
                    imgWidget("assets/images/EarnilyLogo.png", 150, 250),
                    Text(
                      ' كطفل تسجيل الدخول',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),

                    NewText(
                        text: 'رمز التعريف',
                        size: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center),
                         SizedBox(height: 15),
                    reuasbleTextField(
                        "ادخل رمز التعريف", Icons.email, false, _emailController),
                    SizedBox(height: 20),

                      SizedBox(
                      height: 10,
                    ),

                    NewButton(
                        text: 'تسجيل',
                        width: MediaQuery.of(context).size.width,
                        height: 110,
                        onClick: () async {
                          if (_emailController.text.isEmpty ) {
                            _showDialog();
                          } else
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text + '@gmail.com',
                                    password: '12345678')
                                .then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePageKid()));
                            }).onError((error, stackTrace) {
                              print("error ${error.toString()}");
                            });
                        }),

                    SizedBox(height: 20),

                    
                      
                  ],
                ))),
      ),
    );
  }
}
