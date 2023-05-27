// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class kidTasks extends StatefulWidget {
  const kidTasks({Key? key}) : super(key: key);

  @override
  State<kidTasks> createState() => _kidTasksState();
}

String adultID = '';
int points = 0;
int kisPoints = 0;
String kidName = '';

class _kidTasksState extends State<kidTasks> {
  //notification

  final user = FirebaseAuth.instance.currentUser!;
  List _selecteCategorysID = [];

  @override
  void initState() {
    super.initState();
    _getUserDetail();
    _getUserDetail2();

    // getToken();
  }

  String set(String gender) {
    if (gender == "طفلة")
      return "assets/images/girlIcon.png";
    else
      return "assets/images/boyIcon.png";
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

  void _onCategorySelected(bool selected, String tid) {
    if (selected == true) {
      showToastMessage('تم التآكيد! انتظر قبول والدك');

      setState(() {
        _selecteCategorysID.add(tid);
      });
    } else {
      setState(() {
        _selecteCategorysID.add(tid);
      });
    }
  }

  List<Color> myColors = [
    //ghada
    Color(0xffff6d6e),
    Color(0xfff29732),
    Color(0xff6557ff),
    Color(0xff2bc8d9),
    Color(0xff234ebd),

    Color(0xff6DC8F3),
    Color(0xff73A1F9),
    Color(0xffFFB157),
    Color(0xffFFA057),
    Color(0xffFF5B95),
    Color(0xffF8556D),
    Color(0xffD76EF5),
    Color(0xff8F7AFE),
    Color(0xff42E695),
    Color(0xff3BB2B8),
  ];

  Color chooseColor(int index) {
    return myColors[index];
  }

  Future updateTask(String id, String adult) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(adult)
        .collection("Task")
        .doc(id)
        .update({'state': 'pending'});
    await FirebaseFirestore.instance
        .collection('kids')
        .doc(user.email)
        .collection("Task")
        .doc(id)
        .update({'state': 'pending'});
  }

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection('kids')
        .doc(user.email)
        .collection('Task')
        .where('state', isNotEqualTo: 'complete')
        .snapshots();

    final Stream<QuerySnapshot> _stream2 = FirebaseFirestore.instance
        .collection('kids')
        .doc(user.email)
        .collection('Task')
        .where('state', isEqualTo: 'complete')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Center(
            child: Text(
              "مهامي",
              style: TextStyle(fontSize: 40),
            ),
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
                                StreamBuilder(
                                    stream: _stream,
                                    builder: (context, snapshot) {
                                      return Center(
                                        child: !snapshot.hasData
                                            ? Center(
                                                child: Text(
                                                  'لايوجد مهام',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.grey),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              200,
                                                          childAspectRatio:
                                                              29 / 30,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),
                                                  itemBuilder: (ctx, index) {
                                                    Map<String, dynamic>
                                                        document = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    String iconData = '';
                                                    Color iconColor;
                                                    switch (
                                                        document['category']) {
                                                      case "النظافة":
                                                        // iconData = Icons.wash;
                                                        iconData = '🫧';

                                                        iconColor =
                                                            Color(0xffff6d6e);
                                                        break;
                                                      case "الأكل":
                                                        // iconData = Icons.flatware_rounded;
                                                        iconData = '🍽';
                                                        iconColor =
                                                            Color(0xfff29732);
                                                        break;

                                                      case "الدراسة":
                                                        // iconData = Icons.auto_stories_outlined;
                                                        iconData = '📚';
                                                        iconColor =
                                                            Color(0xff6557ff);
                                                        break;

                                                      case "تطوير الشخصية":
                                                        //  iconData = Icons.border_color_outlined;
                                                        iconData = '📖';
                                                        iconColor =
                                                            Color(0xff2bc8d9);
                                                        break;

                                                      case "الدين":
                                                        //  iconData = Icons.brightness_4_rounded;
                                                        iconData = '🕌';
                                                        iconColor =
                                                            Color(0xff234ebd);
                                                        break;
                                                      default:
                                                        // iconData = Icons.brightness_4_rounded;
                                                        iconColor =
                                                            Color(0xff6557ff);
                                                    }
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: iconColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.black,
                                                              offset:
                                                                  const Offset(
                                                                0,
                                                                0.5,
                                                              ),
                                                              blurRadius: 5,
                                                              spreadRadius:
                                                                  0.05,
                                                            ), //BoxShadow
                                                            //BoxShadow
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      //Colors.primaries[Random().nextInt(myColors.length)],

                                                      child: new Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: new GridTile(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 35),
                                                              Text(
                                                                iconData +
                                                                    document[
                                                                        'taskName'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                ),
                                                              ),
                                                              Text(
                                                                '🕐' +
                                                                    document[
                                                                        'date'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                              Text(
                                                                '🌟' +
                                                                    document[
                                                                        'points'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                ),
                                                              ),
                                                              if (document[
                                                                      'state'] ==
                                                                  "Not complete")
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    selected:
                                                                        false,
                                                                    value: _selecteCategorysID
                                                                        .contains(
                                                                            document['tid']),
                                                                    onChanged:
                                                                        (selected) {
                                                                      print(document[
                                                                          'state']);
                                                                      print(
                                                                          document);
                                                                      updateTask(
                                                                          document[
                                                                              'tid'],
                                                                          document[
                                                                              'adult']);

                                                                      _onCategorySelected(
                                                                          selected!,
                                                                          document[
                                                                              'tid']);
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                ),
                                              ),
                                      );
                                    }),
                                StreamBuilder(
                                    stream: _stream2,
                                    builder: (context, snapshot) {
                                      return Center(
                                        child: !snapshot.hasData
                                            ? Center(
                                                child: Text(
                                                  'لايوجد مهام',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.grey),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              200,
                                                          childAspectRatio: 1,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),
                                                  itemBuilder: (ctx, index) {
                                                    Map<String, dynamic>
                                                        document = snapshot
                                                                .data!
                                                                .docs[index]
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;
                                                    String iconData = '';
                                                    Color iconColor;
                                                    switch (
                                                        document['category']) {
                                                      case "النظافة":
                                                        // iconData = Icons.wash;
                                                        iconData = '🫧';

                                                        iconColor =
                                                            Color(0xffff6d6e);
                                                        break;
                                                      case "الأكل":
                                                        // iconData = Icons.flatware_rounded;
                                                        iconData = '🍽';
                                                        iconColor =
                                                            Color(0xfff29732);
                                                        break;

                                                      case "الدراسة":
                                                        // iconData = Icons.auto_stories_outlined;
                                                        iconData = '📚';
                                                        iconColor =
                                                            Color(0xff6557ff);
                                                        break;

                                                      case "تطوير الشخصية":
                                                        //  iconData = Icons.border_color_outlined;
                                                        iconData = '📖';
                                                        iconColor =
                                                            Color(0xff2bc8d9);
                                                        break;

                                                      case "الدين":
                                                        //  iconData = Icons.brightness_4_rounded;
                                                        iconData = '🕌';
                                                        iconColor =
                                                            Color(0xff234ebd);
                                                        break;
                                                      default:
                                                        // iconData = Icons.brightness_4_rounded;
                                                        iconColor =
                                                            Color(0xff6557ff);
                                                    }
                                                    return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                color:
                                                                    iconColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black,
                                                                    offset:
                                                                        const Offset(
                                                                      0,
                                                                      0.5,
                                                                    ),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        0.05,
                                                                  ), //BoxShadow
                                                                  //BoxShadow
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                        child: Container(
                                                          height: 150,
                                                          color:
                                                              iconColor, //Colors.primaries[Random().nextInt(myColors.length)],

                                                          child:
                                                              new Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: new GridTile(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          35),
                                                                  Text(
                                                                    iconData +
                                                                        document[
                                                                            'taskName'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '🕐' +
                                                                        document[
                                                                            'date'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '🌟' +
                                                                        document[
                                                                            'points'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ));
                                                  },
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                ),
                                              ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 150,
        height: 60,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: SizedBox(
          child: FloatingActionButton.extended(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.wallet,
              size: 30,
            ),
            onPressed: () {
              //
            },
            label: Text(
              points.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getUserDetail() {
    FirebaseFirestore.instance
        .collection('kids')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      points2 = snapshot.get("points");
      adultID = snapshot.get("uid");
      //rid = snapshot.get("rid");
      setState(() {});
    });
  }

  _getUserDetail2() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(adultID)
        .collection('kids')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      points = snapshot.get("points");

      setState(() {});
    });
  }
}
