
import 'package:earnilyapp/Rewards/MainRewards.dart';
import 'package:earnilyapp/addKids/adultKids.dart';
import 'package:earnilyapp/screen/profile_screen.dart';
import 'package:earnilyapp/screen/signin_screen.dart';
import 'package:earnilyapp/widgets/MainTask.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../reuasblewidgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
  int _selectedIndex = 0;

  void _showDialogCancel() {
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

  void _navigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    AdultKids(),
    MainTask(),
   
    MainRewards(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.qr_code_scanner_sharp,
          size: 30,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: imgWidget("assets/images/EarnilyLogo.png", 50, 250),
        toolbarHeight: 100,
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
                  //  imgWidget("assets/images/mylogo.png", 200, 100),

                  imgWidget("assets/images/EarnilyLogo.png", 100, 250),
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
                            return const HomePage();
                          },
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: Text(
                      textAlign: TextAlign.right,
                      'ملفي الشخصي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    trailing: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
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
                    onTap: _showDialogCancel,
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
            Icons.child_care,
            color: Colors.white,
            size: 35,
          ),
          Icon(
            Icons.task,
            color: Colors.white,
            size: 35,
          ),
         
          Icon(
            Icons.star,
            color: Colors.white,
            size: 35,
          ),
       
        ],
      ),
    );
  }
}
