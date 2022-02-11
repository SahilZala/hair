import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget
{
  _History createState ()=> _History();
}

class _History extends State<History>
{
  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(FirebaseAuth.instance.currentUser!.uid)));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                //getHistoryWidget(),
                getSalonHistoryList(),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "History",
              textScaleFactor: 0.9,
              style: TextStyle(
                fontFamily: "ubuntur",
                color: getBlackMate(),
                  fontSize: 25
              ),
            ),

            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: getBlackMate(),
                size: 25,
              ),
              onPressed: () {
                _onWillPop();
              },
            ),
          ),
        ),
      ),
    );
  }




  Widget getHistoryWidget(Map orderdata)
  {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

      decoration: BoxDecoration(
        color: orderdata['servicestatus'] == "complete" ? getMateGreen() : getMateRed(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc("${orderdata['userid']}").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                      if(snapshot.hasData)
                      {
                        return Text("${snapshot.data!.data()!['firstname']}",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20,
                            fontFamily: "ubuntub",
                          ),
                        );
                      }
                      else{
                        return Text("wait",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20,
                            fontFamily: "ubuntub",
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    child: Text(
                        orderdata['orderid'],
                        style: TextStyle(
                          color: getGrey(),
                          fontFamily: "ubuntur",
                          fontSize: 10
                        )
                    ),

                  ),


                  // FutureBuilder(
                  //   future: GeoCode().reverseGeocoding(latitude: double.parse(orderdata['lat']), longitude: double.parse(orderdata['log'])),
                  //   builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
                  //     if(snapshot.hasData)
                  //     {
                  //         return Text("${snapshot.data!.city}, ${snapshot.data!.streetNumber}, ${snapshot.data!.streetAddress}, ${snapshot.data!.postal}, ${snapshot.data!.countryName}",
                  //           style: TextStyle(
                  //             color: Colors.grey,
                  //             fontSize: 12,
                  //             fontFamily: "ubuntur",
                  //           ),
                  //         );
                  //     }
                  //     else{
                  //       return Text("address of username should be here.",
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 12,
                  //           fontFamily: "ubuntur",
                  //         ),
                  //       );
                  //     }
                  //   },
                  //
                  // ),

                  //
                  // Text("address of username should be here.",
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 12,
                  //     fontFamily: "ubuntur",
                  //   ),
                  // ),

                  SizedBox(
                    height: 10,
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Text("duration: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "ubuntur",
                          ),
                        ),

                        SizedBox(
                          width: 5,
                        ),

                        Text("${orderdata['totalduration']} min",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 15,
                            fontFamily: "ubuntur",
                          ),
                        ),

                        SizedBox(
                          width: 15,
                        ),

                        Text("price: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "ubuntur",
                          ),
                        ),

                        SizedBox(
                          width: 5,
                        ),

                        Text("Rs. ${orderdata['finaltotal']}/-",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 15,
                            fontFamily: "ubuntur",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            IconButton(
              icon: Icon(
                  Icons.navigate_next_outlined,
                color: getBlackMate(),
              ),
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }

  Widget getSalonHistoryList()
  {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Orders")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("order")
            .where("paymentstatus",isEqualTo: "complete")
            //.where("servicestatus",isEqualTo: "complete")
            //.where("servicestatus",isEqualTo: "cancel")
            .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(snapshot.hasData) {

            if(snapshot.data != null){

              var mainData = snapshot.data?.docs.toList();

              if(mainData?.length != 0) {
                List<Map> actualData = [];

                mainData?.forEach((element) {
                  var pp = element.data();

                  actualData.add(pp);
                });

                //actualData.sort((a, b) => (a['selecteddate'] >= b['selecteddate'] ? 1 : -1));

                actualData.sort((a,b){
                  DateTime adate = DateFormat("dd - MM - yyyy").parse(a['selecteddate']);
                  DateTime bdate = DateFormat("dd - MM - yyyy").parse(b['selecteddate']);

                  if(adate.compareTo(bdate) == -1)
                  {
                    return -1;
                  }
                  else{
                    return 1;
                  }
                });

                print("npnpnpnpnpnpnpnp $actualData");

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: actualData.map((e) {
                      if(e['servicestatus'] != "booked") {
                        return getHistoryWidget(e);
                      }
                      else{
                        return Container();
                      }
                    }).toList(),
                  ),
                );

                return Container();
              }
              else{
                return Container();
              }
            }
            else{
              return Container();
            }

            return SingleChildScrollView(
              child: Column(
                children: [


                ],
              ),
            );
          }
          else{
            return Container();
          }
      },
    );
  }
}