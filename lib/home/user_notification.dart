import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/colors.dart';

import 'new_new_user_home.dart';

class NewNotification extends StatefulWidget
{
  _NewNotification createState ()=> _NewNotification();
}

class _NewNotification extends State<NewNotification>
{

  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => NewUserHome()));

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: getBlackMate(),
          title: Text("Notification",style: TextStyle(color: getMateGold(),fontSize: 18),),
        ),

        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notification").doc(FirebaseAuth.instance.currentUser!.uid).collection("notification").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.data != null) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: snapshot.data!.docs.map((e){
                      return Container(
                        decoration:BoxDecoration(
                            color: getLightGrey(),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(

                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(
                              //   "discoutn",
                              //   textScaleFactor: 0.9,
                              //   style: TextStyle(
                              //       color: getMateGold(),
                              //       fontFamily: "ubuntub",
                              //       fontSize: 20
                              //   ),
                              // ),
                              //
                              // SizedBox(height: 5,),
                              // Container(
                              //
                              //   child: data['discountavailable'] == 'true' ? Wrap(
                              //     children: [
                              //
                              //       Text(
                              //         "₹ ${data['price']}",
                              //         textScaleFactor: 0.9,
                              //         style: TextStyle(
                              //             color: Colors.grey[400],
                              //             fontFamily: "ubuntur",
                              //             fontSize: 15,
                              //             decoration: TextDecoration.lineThrough
                              //         ),
                              //       )
                              //     ],
                              //   ) : SizedBox(),
                              // ),
                            ],
                          ) ,
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              "${e['title'][0].toUpperCase()}",
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntub",

                              ),
                            ) ,
                            foregroundColor: getBlackMate(),
                          ),
                          title: Text(
                            //val.service_category
                            "${e['title']}",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntub",
                                fontSize: 18
                            ),
                          ),

                          subtitle: Text(
                            //val.service_category
                            "${e['body']}",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                fontFamily: "ubuntur",
                                fontSize: 13
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
              );
            }
            else{
              return Container(
                child: Text("no notification at"),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {

    FirebaseFirestore.instance.collection("notification").doc(FirebaseAuth.instance.currentUser!.uid).collection("notification")

        .get()
        .then((data){

      data.docs.forEach((element) {
        print(element.data());
        FirebaseFirestore.instance.collection("notification")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("notification").doc(element.data()['nid'])
            .update({
          'visible': 'true'
        }).whenComplete(() {

        });
      });
    });

    super.initState();
  }
}