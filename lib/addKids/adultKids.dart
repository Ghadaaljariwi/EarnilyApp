import 'dart:ui' as ui;

import 'package:earnilyapp/addKids/adultsKidProfile.dart';
import 'package:earnilyapp/reuasblewidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addkids_screen_1.dart';

import 'package:age_calculator/age_calculator.dart';

class AdultKids extends StatefulWidget {
  const AdultKids({super.key});

  @override
  State<AdultKids> createState() => _AdultKidsState();
}

class _AdultKidsState extends State<AdultKids> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int getBirthday(Timestamp date) {
    int birth = AgeCalculator.age(date.toDate()).years;
    return birth;
  }

  String set(String gender) {
    if (gender == "طفلة")
      return "assets/images/girlIcon.png";
    else
      return "assets/images/boyIcon.png";
  }

  List<Color> myColors = [
    //ghada
    const Color(0xffff6d6e),
    const Color(0xfff29732),
    const Color(0xff6557ff),
    const Color(0xff2bc8d9),
    const Color(0xff234ebd),

    const Color(0xff6DC8F3),
    const Color(0xff73A1F9),
    const Color(0xffFFB157),
    const Color(0xffFFA057),
    const Color(0xffFF5B95),
    const Color(0xffF8556D),
    const Color(0xffD76EF5),
    const Color(0xff8F7AFE),
    const Color(0xff42E695),
    const Color(0xff3BB2B8),
  ];

  Color chooseColor(int index) {
    return myColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('kids')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Center(
            child: Text(
              "أطفالي",
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text(
                  "لا يوجد لديك أطفال \n قم بالإضافة الآن",
                  style: TextStyle(fontSize: 30, color: Colors.grey),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 5 / 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (contex, index) {
                    Map<String, dynamic> document = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;

                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => AdultsKidProfile(
                                      document: document,
                                      id: snapshot.data?.docs[index].id
                                          as String
                                      //pass doc
                                      )));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: chooseColor(index),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(
                                    0,
                                    0.5,
                                  ),
                                  blurRadius: 5,
                                  spreadRadius: 0.05,
                                ), //BoxShadow
                                //BoxShadow
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: GridTile(
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  imgWidget(set(document['gender']), 64, 64),

                                  Text(
                                    document['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  // IconButton(
                                  //   icon: Icon(Icons.account_circle_sharp),
                                  //   color: Colors.black,
                                  //   iconSize: 40,
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (builder) =>
                                  //                 AdultsKidProfile(
                                  //                     document: document,
                                  //                     id: snapshot
                                  //                         .data
                                  //                         ?.docs[index]
                                  //                         .id as String
                                  //                     //pass doc
                                  //                     )));
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                  itemCount: snapshot.data!.docs.length,
                ),
              );
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
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
      ),
    );
  }
}
