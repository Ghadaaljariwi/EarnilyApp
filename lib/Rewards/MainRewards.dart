import 'dart:ui' as ui;

import 'package:earnilyapp/Rewards/addReward.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:age_calculator/age_calculator.dart';

class MainRewards extends StatefulWidget {
  const MainRewards({super.key});

  @override
  State<MainRewards> createState() => _MainRewardsState();
}

class _MainRewardsState extends State<MainRewards> {
 
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

void _showRewardSelected()  {
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
              "طفلك اختار هذه المكافاة ",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
            actions: [
              cancelButton,
            ]

);
        }
   );
}

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
  
          .collection('users')
      .doc(user.uid)
      .collection('reward')
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
              "مكافآت اطفالي",
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          return new Directionality(
            textDirection: ui.TextDirection.rtl,
            child: !snapshot.hasData
                ? Center(
                    child: Text(
                      "لا يوجد لديك مكافآت \n قم بالإضافة الآن",
                      style: TextStyle(fontSize: 30, color: Colors.grey),
                    ),
                  )
                :Padding(
                                                                   padding:     const EdgeInsets.all(20.0),

                      child: GridView.builder(
                         gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              200
                                                              ,
                                                          childAspectRatio:
                                                              29 / 30,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),
                                                  
                        
                        itemBuilder: (ctx, index) {
                          Map<String, dynamic> document =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return Container(
                             alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: chooseColor(index),
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
                                       
                              child: Container(
                                height: 200,
                                color: chooseColor(
                                    index), //Colors.primaries[Random().nextInt(myColors.length)],

                                child: new Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: new GridTile(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Icon(
                                          Icons.card_giftcard,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          document['rewardName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          document['points'] + '🌟',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                              if (document['state'] =='selected')
                                    IconButton(
                                      icon: Icon(Icons.check),
                                      color: Colors.black,
                                      onPressed: () =>{
                                        _showRewardSelected()

                                            },
                                      ),
                                        ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                        itemCount: snapshot.data!.docs.length,
           
                      ),
                    ),   );
        }
      ),
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
                return const add_Reward();
              },
            ),
          );
        },
      ),
    );
  }
}
