// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:earnilyapp/widgets/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:earnilyapp/widgets/view_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainTask extends StatefulWidget {
  const MainTask({super.key});

  @override
  State<MainTask> createState() => _MainTaskState();
}

class _MainTaskState extends State<MainTask> {
  final user = FirebaseAuth.instance.currentUser!;
  //snapShot.data[index]
  void initState() {
    super.initState();
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

  Future updateTask(String id, String adult, String kid, int point) async {
    showToastMessage('تم قبول النشاط');
    Navigator.of(context).pop();
    int pn = 0;
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(adult)
            .collection('kids')
            .doc(kid + '@gmail.com')
            .snapshots()
            .listen((DocumentSnapshot snapshot) {
      pn = snapshot.get("points")+point ;
      

    });
    // points += point;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(adult)
        .collection("Task")
        .doc(id)
        .update({'state': 'complete'});
    await FirebaseFirestore.instance
        .collection('kids')
        .doc(kid + '@gmail.com')
        .collection("Task")
        .doc(id)
        .update({'state': 'complete'});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(adult)
        .collection('kids')
        .doc(kid + '@gmail.com')
        .update({'points':pn});

    await FirebaseFirestore.instance
        .collection('kids')
        .doc(kid + '@gmail.com')
        .update({'points': pn});
  }

  Future delete(String id, String adult, String kid, String msg) async {
    showToastMessage(msg);
    Navigator.of(context).pop();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(adult)
        .collection("Task")
        .doc(id)
        .delete();
    await FirebaseFirestore.instance
        .collection('kids')
        .doc(kid + '@gmail.com')
        .collection("Task")
        .doc(id)
        .delete();
  }

  Future delete2(String id, String adult, String kid, String msg) async {
    showToastMessage(msg);
    Navigator.of(context).pop();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(adult)
        .collection("Task")
        .doc(id)
        .delete();
    await FirebaseFirestore.instance
        .collection('kids')
        .doc(kid + '@gmail.com')
        .collection("Task")
        .doc(id)
        .delete();
  }

  void _showDialog(String id, String adult, String kid, String points) {
    var point = int.parse(points);
    showDialog(
        context: context,
        builder: (context) {
          // set up the buttons
          Widget cancelButton = TextButton(
            child: Text(
              "رفض",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            onPressed: () {
              // Navigator.of(context).pop;
              delete(id, adult, kid, 'تم رفض النشاط');
            },
          );
          Widget continueButton = TextButton(
            child: Text(
              "قبول",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () {
              Navigator.of(context).pop;
              updateTask(id, adult, kid, point);
            },
          );

          Widget backButton = TextButton(
            child: Text(
              "تراجع",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: Navigator.of(context).pop,
          );
          return AlertDialog(
            title: Text(
              'قبول اتمام المهمة',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'هل انت متاكد بقبول مهمة طفلك؟',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              backButton,
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  void _showDialog2() {
    showDialog(
        context: context,
        builder: (context) {
          // set up the buttons
          Widget cancelButton = TextButton(
            child: Text(
              "حسنا",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: Navigator.of(context).pop,
          );

          return AlertDialog(
            title: Text(
              'طفلك لم يكمل المهمة بعد',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            actions: [
              cancelButton,
            ],
          );
        });
  }

  void _showDialog3(String id, String adult, String kid) {
    showDialog(
        context: context,
        builder: (context) {
          // set up the buttons
          Widget cancelButton = TextButton(
            child: Text(
              "لا",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            onPressed: Navigator.of(context).pop,
          );
          Widget continueButton = TextButton(
            child: Text(
              "نعم",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () {
              delete2(id, adult, kid, 'تم حذف النشاط');
            },
          );

          return AlertDialog(
            title: Text(
              'حذف المهمة من طفلك',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            content: Text(
              'هل انت متاكد بحذف مهمة طفلك؟',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  int dd = 0;
  String _colors(String i, String kid) {
    if (i == "Not complete") {
      return 'غير مكتمل🔴';
    } else if (i == "pending") {
      if (dd == 0) dd++;
      return 'انتظار موافقتك🟠';
    } else
      return 'مكتمل🟢';
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Task')
        .where('state', isNotEqualTo: 'complete')
        .snapshots();

    final Stream<QuerySnapshot> _stream2 = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Task')
        .where('state', isEqualTo: 'complete')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Center(
          child: Text(
            'انشطة اطفالي ',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      body: SafeArea(
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                            indicatorColor: Colors.black,
                            tabs: [
                              Tab(
                                text: ' الحالية',
                              ),
                              Tab(
                                text: ' السابقة',
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Center(
                                  child: StreamBuilder(
                                      stream: _stream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            "لا يوجد لديك مهام \n قم بالإضافة الآن",
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.grey),
                                          );
                                        }

                                        return ListView.builder(
                                          itemBuilder: (Context, index) {
                                            Map<String, dynamic> document =
                                                snapshot.data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>;

                                            IconData iconData;
                                            Color iconColor;
                                            switch (document['category']) {
                                              case "النظافة":
                                                iconData = Icons.wash;

                                                iconColor = Color(0xffff6d6e);
                                                break;
                                              case "الأكل":
                                                iconData =
                                                    Icons.flatware_rounded;
                                                iconColor = Color(0xfff29732);
                                                break;

                                              case "الدراسة":
                                                iconData =
                                                    Icons.auto_stories_outlined;
                                                iconColor = Color(0xff6557ff);
                                                break;

                                              case "تطوير الشخصية":
                                                iconData =
                                                    Icons.border_color_outlined;
                                                iconColor = Color(0xff2bc8d9);
                                                break;

                                              case "الدين":
                                                iconData =
                                                    Icons.brightness_4_rounded;
                                                iconColor = Color(0xff234ebd);
                                                break;
                                              default:
                                                iconData =
                                                    Icons.brightness_4_rounded;
                                                iconColor = Color(0xff6557ff);
                                            }
                                            return Card(
                                                elevation: 5,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 5,
                                                ),
                                                child: new Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: new ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            iconColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        radius: 30,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            child: Container(
                                                              height: 33,
                                                              width: 36,
                                                              child: Icon(
                                                                  iconData),
                                                            )),
                                                      ),
                                                      title: Text(
                                                        document['taskName'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        '${document['asignedKid']}\n${document['points']}🌟 | ${_colors(document['state'], document['asignedKid'])}',
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                      isThreeLine: true,
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (builder) => View_task(
                                                                    document:
                                                                        document,
                                                                    id: snapshot
                                                                        .data
                                                                        ?.docs[
                                                                            index]
                                                                        .id as String
                                                                    //pass doc
                                                                    )));
                                                      },
                                                      trailing: Wrap(
                                                          spacing: 0,
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor,
                                                              onPressed: () => {
                                                                //delete
                                                                _showDialog3(
                                                                    document[
                                                                        'tid'],
                                                                    document[
                                                                        'adult'],
                                                                    document[
                                                                        'kidpass'])
                                                              },
                                                            ),
                                                            if (document[
                                                                    'state'] ==
                                                                'pending')
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .check),
                                                                color: Colors
                                                                    .black,
                                                                onPressed: () =>
                                                                    {
                                                                  if (document[
                                                                          'state'] ==
                                                                      'pending')
                                                                    _showDialog(
                                                                        document[
                                                                            'tid'],
                                                                        document[
                                                                            'adult'],
                                                                        document[
                                                                            'kidpass'],
                                                                        document[
                                                                            'points'])
                                                                  else
                                                                    _showDialog2()
                                                                },
                                                              ),
                                                          ])),
                                                ));
                                          },
                                          itemCount: snapshot.data!.docs.length,
                                        );
                                      }),
                                ),
                                Center(
                                  child: StreamBuilder(
                                      stream: _stream2,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            "لا يوجد لديك مهام \n قم بالإضافة الآن",
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.grey),
                                          );
                                        }

                                        return ListView.builder(
                                          itemBuilder: (Context, index) {
                                            Map<String, dynamic> document =
                                                snapshot.data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>;

                                            IconData iconData;
                                            Color iconColor;
                                            switch (document['category']) {
                                              case "النظافة":
                                                iconData = Icons.wash;

                                                iconColor = Color(0xffff6d6e);
                                                break;
                                              case "الأكل":
                                                iconData =
                                                    Icons.flatware_rounded;
                                                iconColor = Color(0xfff29732);
                                                break;

                                              case "الدراسة":
                                                iconData =
                                                    Icons.auto_stories_outlined;
                                                iconColor = Color(0xff6557ff);
                                                break;

                                              case "تطوير الشخصية":
                                                iconData =
                                                    Icons.border_color_outlined;
                                                iconColor = Color(0xff2bc8d9);
                                                break;

                                              case "الدين":
                                                iconData =
                                                    Icons.brightness_4_rounded;
                                                iconColor = Color(0xff234ebd);
                                                break;
                                              default:
                                                iconData =
                                                    Icons.brightness_4_rounded;
                                                iconColor = Color(0xff6557ff);
                                            }
                                            return Card(
                                                elevation: 5,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 5,
                                                ),
                                                child: new Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: new ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            iconColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        radius: 30,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            child: Container(
                                                              height: 33,
                                                              width: 36,
                                                              child: Icon(
                                                                  iconData),
                                                            )),
                                                      ),
                                                      title: Text(
                                                        document['taskName'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        '${document['asignedKid']}\n${document['points']}🌟 | ${_colors(document['state'], document['asignedKid'])}',
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                      isThreeLine: true,
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (builder) =>
                                                                        View_task(
                                                                          document:
                                                                              document,
                                                                          id: snapshot
                                                                              .data
                                                                              ?.docs[index]
                                                                              .id as String,
                                                                        )));
                                                      },
                                                      trailing: Wrap(
                                                          spacing: 0,
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor,
                                                              onPressed: () => {
                                                                //delete
                                                                _showDialog3(
                                                                    document[
                                                                        'tid'],
                                                                    document[
                                                                        'adult'],
                                                                    document[
                                                                        'asignedKid'])
                                                              },
                                                            ),
                                                            if (document[
                                                                    'state'] ==
                                                                'pending')
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .check),
                                                                color: Colors
                                                                    .black,
                                                                onPressed: () =>
                                                                    {
                                                                  if (document[
                                                                          'state'] ==
                                                                      'pending')
                                                                    _showDialog(
                                                                        document[
                                                                            'tid'],
                                                                        document[
                                                                            'adult'],
                                                                        document[
                                                                            'kidpass'],
                                                                        document[
                                                                            'points'])
                                                                  else
                                                                    _showDialog2()
                                                                },
                                                              ),
                                                          ])),
                                                ));
                                          },
                                          itemCount: snapshot.data!.docs.length,
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const Add_task();
              },
            ),
          );
        },
      ),
    );
  }
}
