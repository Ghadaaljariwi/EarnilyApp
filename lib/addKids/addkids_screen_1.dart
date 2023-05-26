// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:earnilyapp/reuasblewidgets.dart';
import 'package:earnilyapp/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:earnilyapp/models/kid.dart';

class AddKids_screen_1 extends StatefulWidget {
  const AddKids_screen_1({Key? key}) : super(key: key);

  @override
  _AddKids_screen_1 createState() => _AddKids_screen_1();
}

class _AddKids_screen_1 extends State<AddKids_screen_1> {
  final TextEditingController nameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String? value;
  DateTime? date;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<String> items = <String>["طفل", "طفلة"];

  //final _nameController = TextEditingController();
  List<kid> names = [];
  int count = 0;

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "خطأ",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              text,
              textAlign: TextAlign.right,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("حسناً"),
              )
            ],
          );
        });
  }

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
            'هل انت متأكد من إلغاء العملية ؟',
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) {
                    return count++ == 2;
                  },
                );
              },
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("البقاء"),
            )
          ],
        );
      },
    );
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
        );
  }

  Future<void> _validate() async { // <emailController, emailController == '  '
    if (nameController.text.isEmpty || value == null || date == null) {
      _showDialog("ادخل البيانات المطلوبة");
    } else {
      names = await lstKids();
      if (myLoop(names)) {
        _showDialog("ممنوع إدخال معلومات مكررة");
      } else {
        addKidDetails();
        showToastMessage("تمت إضافة الطفل بنجاح");

        Navigator.of(context).pop();
      }
    }
  }

  void validateReturn(bool flag) {
    if (flag) {
      _showDialog("هل انت متأكد من الخروج ؟");
    }
  }

  Future addKidDetails() async {
    var uuid = Uuid();
    String u = uuid.v4();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('kids')
        .doc(u.substring(0, 8) + '@gmail.com')
        .set({
      'name': nameController.text,
      'gender': value,
      'date': date,
      'point': 0,
      'uid': user.uid,
      'pass': u.substring(0, 8),
      'points': 0,
    });

    await FirebaseFirestore.instance
        .collection('kids')
        .doc(u.substring(0, 8) + '@gmail.com')
        .set({
      'name': nameController.text,
      'gender': value,
      'date': date,
      'point': 0,
      'uid': user.uid,
      'pass': u.substring(0, 8),
      'points': 0,
    });
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: u.substring(0, 8) + '@gmail.com', password: '12345678');
  }

  void _showDatePicker() async => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2007),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value == null) {
          return;
        }
        setState(() {
          date = value;
        });
      });

  bool myLoop(List<kid> list) {
    for (var i = 0; i < list.length; i++) {
      if (nameController.text == list[i].name) {
        return true;
      }
    }
    return false;
  }

  Future<List<kid>> lstKids() async {
    final user = FirebaseAuth.instance.currentUser!;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('kids')
        .where(name)
        .get();

    List<kid> _kidsNamesList = [];

    for (var i = 0; i < snapshot.docs.length; i++) {
      Map<String, dynamic> document =
          snapshot.docs[i].data() as Map<String, dynamic>;

      String name = document['name'];
      String pass = document['pass'];
      kid kididentifier = kid(name: name, email: pass);
      _kidsNamesList.add(kididentifier);
    }

    return _kidsNamesList;
  }

  @override
  Widget build(BuildContext context) {
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
              _showDialogCancel();
            },
          )
        ],
        backgroundColor: Colors.black,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Center(
              child: Text(
                "إضافة طفل",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.02, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(),
                    SizedBox(height: 30),
                    //Image.asset("assets/images/ChildrenFreepik.png"),
                    imgWidget("assets/images/ChildrenFreepik.png", 100, 100),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "الاسم",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        controller: nameController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "اسم الطفل ",
                            hintTextDirection: ui.TextDirection.rtl,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            )),
                      ),
                    ),

                    Positioned(
                        right: 107,
                        top: 300,
                        width: 254,
                        height: 66,
                        child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(18),
                            child: new Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Row(
                                      //female
                                      children: [
                                        Radio(
                                            value: items[1],
                                            groupValue: value,
                                            onChanged: (newValue) {
                                              setState(() {
                                                value = newValue!;
                                              });
                                            }),
                                        Text(
                                          items[1],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),

                                        //Image.asset("assets/images/girl.png"),
                                        imgWidget("assets/images/girlIcon.png",
                                            32, 32),

                                        /*Icon(Icons.child_care,
                                            color: Colors.pink),*/
                                      ],
                                    ),
                                    Row(
                                      //male
                                      children: [
                                        Radio(
                                            value: items[0],
                                            groupValue: value,
                                            onChanged: (newValue) {
                                              setState(() {
                                                value = newValue!;
                                              });
                                            }),
                                        Text(
                                          items[0],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        imgWidget("assets/images/boyIcon.png",
                                            32, 32),
                                      ],
                                    )
                                  ],
                                )))),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        " تاريخ الميلاد",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //ghada
                    /*
                    Positioned(
                      right: 107,
                      top: 425,
                      child: new Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: _showDatePicker,
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                icon: Icon(
                                  Icons.calendar_today,
                                  size: 30,
                                )),
                            Text(
                              date == null
                                  ? 'اختر تاريخ الميلاد'
                                  : '${DateFormat.yMd().format(date!)}',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                              textDirection: ui.TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                      */

                    SizedBox(
                      //width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _showDatePicker,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(18),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: new Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date == null
                                    ? 'اختر تاريخ الميلاد'
                                    : '${DateFormat.yMd().format(date!)}',
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 60,
                    ),
                    Positioned(
                        left: 21,
                        top: 625,
                        width: 350,
                        height: 66,
                        child: SizedBox(
                            width: 347,
                            height: 68,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                    width: 0,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              onPressed: _validate,
                              child: const Text('إضافة ',
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ))),
                  ],
                ))),
      ),
    );
  }
}
