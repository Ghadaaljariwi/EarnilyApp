// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:earnilyapp/models/kid.dart';
import 'package:earnilyapp/screen/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Add_task extends StatefulWidget {
  const Add_task({super.key});

  @override
  State<Add_task> createState() => _Add_taskState();
}

class _Add_taskState extends State<Add_task> {
  @override
  //notification

  void initState() {
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _selectedDate = "";
  final _nameController = TextEditingController();
  String categoty = "";
  String childName = "";
  String points = '';
  int count = 0;
  //List<String> list = [];
  // namesListClass forThePurposeOfTheList = namesListClass();

  void _showDialog() {
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
              "ادخل البيانات المطلوبة",
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
    //raghad
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white,

        //message text color

        fontSize: 16.0 //message font size
        );
  }

  void _validate() {
    if (formKey.currentState!.validate() &&
        categoty != "" &&
        points != "" &&
        _selectedDate != "" &&
        childName != "") {
      addTask();

      showToastMessage("تمت إضافة نشاط بنجاح");

      Navigator.of(context).pop();
    } else {
      _showDialog();
    }
  }

  Future<String> getEmail(String childName) async {
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

    for (var i = 0; i < _kidsNamesList.length; i++) {
      if (childName == _kidsNamesList[i].name) {
        return _kidsNamesList[i].email;
      }
      return 'e388e604';
    }
    return 'e388e604';
  }

  Future addTask() async {
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

    for (var i = 0; i < _kidsNamesList.length; i++) {
      if (childName == _kidsNamesList[i].name) {
        email = _kidsNamesList[i].email;
      }
    }

    const tuid = Uuid();
    String tid = tuid.v4();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Task')
        .doc(tid)
        .set({
      'taskName': _nameController.text,
      'points': points,
      'date': _selectedDate,
      'category': categoty,
      'asignedKid': childName,
      'state': 'Not complete',
      'tid': tid,
      'adult': user.uid,
      'kidpass': email,
    });

    await FirebaseFirestore.instance
        .collection('kids')
        .doc(email + '@gmail.com')
        .collection('Task')
        .doc(tid)
        .set({
      'taskName': _nameController.text,
      'points': points,
      'date': _selectedDate,
      'category': categoty,
      'asignedKid': childName,
      'state': 'Not complete',
      'tid': tid,
      'adult': user.uid,
      'kidpass': email,
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  Future<List<String>> lstKids() async {
    final user = FirebaseAuth.instance.currentUser!;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('kids')
        .where(name)
        .get();

    List<String> _kidsNamesList = [];

    for (var i = 0; i < snapshot.docs.length; i++) {
      Map<String, dynamic> document =
          snapshot.docs[i].data() as Map<String, dynamic>;

      String name = document['name'];
      _kidsNamesList.add(name);
    }

    return _kidsNamesList;
  }

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
        title: Center(
          child: Text(
            'إضافة نشاط',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ":اسم النشاط ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                          controller: _nameController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: ' اسم النشاط الجديد',
                              hintTextDirection: ui.TextDirection.rtl,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                              )),
                          validator: (val) {
                            var msg;
                            if (val!.isEmpty) {
                              msg = 'اختر اسم النشاط';
                            }
                            return msg;
                          }
                          //onChanged: (val) => setState(() => _currentName = val),
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ":اختر الطفل المخصص للنشاط",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15)),
                        child: FutureBuilder(
                          future: lstKids(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              print(snapshot.data);

                              return DropdownButtonFormField<String>(
                                  hint: childName.isEmpty
                                      ? Text("اختر الطفل")
                                      : Text(childName),
                                  isExpanded: true,
                                  alignment: Alignment.centerRight,
                                  // validator: (val) {
                                  //   if (val == null) return "اختر الطفل";
                                  //   return null;
                                  // },
                                  items: snapshot.data?.map((valueItem) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      childName = newVal!;
                                    });
                                  });
                            } else {
                              return SizedBox(
                                height: 10,
                              );
                            }
                          },
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ":عدد النقاط المستحقة",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        children: [
                          pointsSelect("100", 0xffff6d6e),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('75', 0xfff29732),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('50', 0xff6557ff),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('25', 0xff2bc8d9),
                        ]
                        /* children: [
                          pointsSelect("١٠٠", 0xffff6d6e),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('٧٥', 0xfff29732),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('٥٠', 0xff6557ff),
                          SizedBox(
                            width: 20,
                          ),
                          pointsSelect('٢٥', 0xff2bc8d9),
                        ] */
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ":تاريخ التنفيذ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      //width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _presentDatePicker,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(18),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: new Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == ""
                                    ? 'لم يتم اختيار تاريخ'
                                    : 'التاريخ المختار: ${_selectedDate}',
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
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ":نوع النشاط",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        children: [
                          categorySelect("النظافة", 0xffff6d6e),
                          SizedBox(
                            width: 20,
                          ),
                          categorySelect('الأكل', 0xfff29732),
                          SizedBox(
                            width: 20,
                          ),
                          categorySelect('الدراسة', 0xff6557ff),
                          SizedBox(
                            width: 20,
                          ),
                          categorySelect('الدين', 0xff234ebd),
                          SizedBox(
                            width: 20,
                          ),
                          categorySelect('تطوير الشخصية', 0xff2bc8d9),
                        ]),
                    SizedBox(
                      height: 30,
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

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: (() {
        setState(() {
          categoty = label;
        });
      }),
      child: Chip(
        // backgroundColor: categoty == label ? Color(color) : Colors.grey,
        backgroundColor: categoty.isEmpty
            ? Color(color)
            : categoty == label
                ? Color(color)
                : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
   label: textChip(label),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.5,
        ),
      ),
    );
  }

  Widget pointsSelect(String label, int color) {
    return InkWell(
      onTap: (() {
        setState(() {
          points = label;
        });
      }),
      child: Chip(
        backgroundColor: points.isEmpty
            ? Color(color)
            : points == label
                ? Color(color)
                : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
         label: textChip(label),

        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.5,
        ),
      ),
    );
  }
 Widget textChip(String label) {
    return Text(
      label,
      style: TextStyle(
        color: categoty.isEmpty
            ? Colors.white
            : categoty == label
                ? Colors.white
                : Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  //notification
}
