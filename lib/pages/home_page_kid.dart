import 'dart:math';

import 'package:earnilyapp/Rewards/kidrewards.dart';
import 'package:earnilyapp/addKids/adultsKidProfile.dart';
import 'package:earnilyapp/pages/KidTasks.dart';
import 'package:earnilyapp/reuasblewidgets.dart';
import 'package:earnilyapp/screen/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class HomePageKid extends StatefulWidget {
  const HomePageKid({super.key});

  @override
  State<HomePageKid> createState() => _HomePageKidState();
}

class _HomePageKidState extends State<HomePageKid> {
  bool isLoading = false;

  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
  int _selectedIndex = 0;

  void _navigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      //barrierDismissible = false;
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "لحظة",
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'هل انت متأكد من تسجيل الخروج ؟',
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                /////
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SignInScreen();
                    },
                  ),
                );
                //do
              },
              child: const Text("تأكيد"),
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("إلغاء"),
            )
          ],
        );
      },
    );
  }

  final List<Widget> _pages = [
    kidTasks(),
    kidreward(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: imgWidget("assets/images/EarnilyLogo.png", 50, 250),
        ),
        // title: Text(
        //  'E A R N I L Y',
        //  style: TextStyle(fontSize: 35),
        // ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.05, 20, 0),
            child: Column(

                //   DrawerHeader(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imgWidget("assets/images/EarnilyLogo.png", 100, 250),
                  Text(
                    'اعدادات',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(
                    '________________________________',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      textAlign: TextAlign.right,
                      'الصفحة الرئيسية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    trailing: Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HomePageKid();
                          },
                        ),
                      );
                    },
                  ),
                  Text(
                    '________________________________',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      textAlign: TextAlign.right,
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: _showLogoutDialog,
                  ),

                  /* child: MaterialButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const SignInScreen();
                              },
                            ),
                          );
                        },
                        color: Colors.white,
                        child:
                            Text(' تسجيل خروج', style: TextStyle(fontSize: 19)),
                      ),*/
                ]),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        onTap: _navigationBar,
        items: [
          Icon(
            Icons.playlist_add_sharp,
            color: Colors.white,
            size: 35,
          ),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 35,
          ),
        ],
      ), /*
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const AddKids_screen_1();
              },
            ),
          );
        },
      ),*/
    );
  }

  ImagePicker picker = ImagePicker();

  File? file;
  String imageUrl = "";

  loadingTrue() {
    isLoading = true;
    setState(() {});
  }

  loadingFalse() {
    isLoading = false;
    setState(() {});
  }
}
