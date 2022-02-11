import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/handle_notification.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class OrdersData extends StatefulWidget
{
  OrderClass oc;
  _OrdersData createState ()=> _OrdersData(oc);

  OrdersData(this.oc);
}

class _OrdersData extends State<OrdersData>
{
  OrderClass oc;

  _OrdersData(this.oc);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BarberDashboard(FirebaseAuth.instance.currentUser!.uid)));

        return false;

      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(

            padding: EdgeInsets.all(15),
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                getUserData(),


                getSelectedServiceList(),

                SizedBox(
                    height: 30
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         "Seat number",
                //         textScaleFactor: 0.9,
                //         style: TextStyle(
                //             color: getBlackMate(),
                //             fontSize: 20
                //         ),
                //
                //       ),
                //     ),
                //
                //     Expanded(
                //       child: Text(
                //
                //         "${oc.seatnumber}",
                //         textScaleFactor: 0.9,
                //         textAlign: TextAlign.right,
                //         style: TextStyle(
                //             color: getGrey(),
                //             fontSize: 20
                //         ),
                //
                //       ),
                //     )
                //   ],
                // ),

                SizedBox(
                    height: 15
                ),

                Container(
                  child: Text(
                      "Orderid",
                      style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntur",
                          fontSize: 18
                      )
                  ),

                ),

                SizedBox(
                  height: 15,
                ),

                Container(
                  child: Text(
                      oc.orderid,
                      style: TextStyle(
                        color: getMateGold(),
                        fontFamily: "ubuntur",
                      )
                  ),

                ),


                getOtpWidget(),

                SizedBox(
                  height: 30
                ),

                getMaterialButton()
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: getBlackMate(),
            title: Text(
              "Order",
              textScaleFactor: 0.9,
              style: TextStyle(
                color: getMateGold(),
                fontFamily: "ubuntur",

              ),
            ),

            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: getMateGold(),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BarberDashboard(FirebaseAuth.instance.currentUser!.uid)));
              },
            ),
          ),
        ),
      ),
    );
  }



  Widget getUserData()
  {
    
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(oc.userid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
            if(snapshot.data != null)
            {
              return Container(
                  width: MediaQuery.of(context).size.width,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,


                    children: [

                      SizedBox(
                          height: 20
                      ),

                      Container(
                          width: MediaQuery.of(context).size.width,

                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                height: 160,width: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                    color: getLightGrey(),

                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(360),
                                    color: getLightGrey(),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data?.data()!['profile'],
                                      ),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),


                      SizedBox(
                        height: 30
                      ),

                      Text(
                        "username",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: getGrey(),
                          fontFamily: "ubuntur",

                        )
                      ),

                      SizedBox(height: 5,
                      ),

                      Text(
                        "${snapshot.data?.data()!['firstname']} ${snapshot.data?.data()!['lastname']}",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntub",
                          fontSize: 25,
                        ),
                      ),

                      SizedBox(height: 20,),

                      Text(
                          "address",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getGrey(),
                            fontFamily: "ubuntur",

                          )
                      ),

                      SizedBox(height: 10,),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: getMateGold(),
                              size: 18,
                            ),

                            SizedBox(
                                width: 5
                            ),

                            FutureBuilder(
                              future: geoCode.reverseGeocoding(latitude: double.parse(oc.lat), longitude: double.parse(oc.log)),
                              builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {

                                if(snapshot.hasData) {

                                  return Text(
                                    "${snapshot.data!.city}, ${snapshot.data!.streetNumber}, ${snapshot.data!.streetAddress}, ${snapshot.data!.postal}, ${snapshot.data!.countryName},",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                      color: getBlackMate(),
                                      fontFamily: "ubuntur",
                                      fontSize: 18,
                                    ),
                                  );
                                }
                                else{
                                  return Text("address",textScaleFactor: 0.9,);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),



                    ],
                  )
              );
            }
            else{
              return Container();
            }
        }
        else{
          return Container();
        }
      },
    );
  }

  Widget getOtpWidget()
  {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 30),
          Text(
            "Take otp from user",
            textScaleFactor: 0.9,
            style: TextStyle(
              color: getBlackMate(),
              fontFamily: "ubuntur",
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: _otp,
              validator: (value) {
                if(value!.isEmpty)
                {
                  return 'please enter otp';
                }
                else if(value.length < 6)
                {
                  return 'please enter 6 digit otp';
                }

                return null;

              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20//scaleFactor
              ),

              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "enter otp",
                // prefixIcon: Container(
                //   width: 22,
                //   height: 22,
                //   alignment: Alignment.center,
                //   // child: Text("₹",
                //   //   textAlign: TextAlign.center,
                //   //   textScaleFactor: 0.9,
                //   //   style: TextStyle(
                //   //       color: getBlackMate(),
                //   //       fontFamily: "ubuntur",
                //   //       fontSize: 22
                //   //   ),
                //   // ),
                // ),

                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2,color: getBlackMate()),
                    borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 2,color: getBlackMate())
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget getSelectedServiceList()
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "services",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                ),
              ),
            ),

            Text(
              "price",
              textScaleFactor: 0.9,
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntur",
                fontSize: 20,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),


        oc.servicetype == "service" ? Column(
          children: oc.serviceid.map((e){

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  .doc(oc.vendorid)
                  .collection("service")
                  .doc(e).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasData)
                {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              "${snapshot.data?.data()!['servicename']}",
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                  fontSize: 15
                              ),
                            )
                        ),
                        Text(
                          "Rs ${snapshot.data?.data()!['price']} /-",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntur",
                              fontSize: 15
                          ),
                        )
                      ],
                    ),
                  );
                }
                else{
                  return Container();
                }
              },
            );
            return Container();
          }).toList(),
        ) : Column(
          children: oc.serviceid.map((e){

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("packages")
                  .doc(oc.vendorid)
                  .collection("package")
                  .doc(e).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasData)
                {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              "${snapshot.data?.data()!['packagename']}",
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                  fontSize: 15
                              ),
                            )
                        ),
                        Text(
                          "Rs ${snapshot.data?.data()!['price']} /-",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntur",
                              fontSize: 15
                          ),
                        )
                      ],
                    ),
                  );
                }
                else{
                  return Container();
                }
              },
            );
            return Container();
          }).toList(),
        ),

        SizedBox(
            height: 5
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "tax",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "+ Rs ${oc.tax} /-",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 15
              ),
            )
          ],
        ),

        SizedBox(
            height: 10
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "discount",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "- Rs ${oc.disount} /-",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 15
              ),
            )
          ],
        ),





        SizedBox(height: 20,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 2,
          color: getGrey(),
        ),

        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "final total",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "Rs ${oc.finaltotal} /-",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 15
              ),
            )
          ],
        ),



        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "total duration",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "${oc.totalduration} Minutes",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 15
              ),
            )
          ],
        ),

      ],
    );
  }

  Widget getMaterialButton()
  {
    return Container(

      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: getBlackMate(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        color: getBlackMate(),
        onPressed: (){
          if(_formKey.currentState!.validate())
          {
            print(oc.orderid);
            oc.verifyOtp(oc.userid, oc.orderid, oc.vendorid).then((value){
              if(value.data() != null)
              {
                if(value.data()!['otp'] == _otp.text)
                {
                  oc.updateOrderStatus(oc.orderid,oc.vendorid,oc.userid).then((value){

                    print(oc.orderid);
                    print(oc.userid);
                    oc.updateOrderStatusAfterDone(oc.orderid,oc.vendorid, oc.userid).then((value){

                      sendNotifications("complete","booking complete on ${oc.selecteddate}","complete","extra",oc.userid,oc.vendorid);

                      showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message: "Order Completed",
                            textStyle: TextStyle(
                                fontFamily: "ubuntub",
                                color: Colors.white,
                                fontSize: 15
                            ),
                          )
                      );
                    });
                  });
                }
                else{
                  showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message: "wrong otp",
                        textStyle: TextStyle(
                            fontFamily: "ubuntub",
                            color: Colors.white,
                            fontSize: 15
                        ),
                      )
                  );
                }
              }
              else{
                showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message: "otp is not generated at",
                      textStyle: TextStyle(
                          fontFamily: "ubuntub",
                          color: Colors.white,
                          fontSize: 15
                      ),
                    )
                );
              }

              print(value.data());
            });
          }
        },

        child: Text(
          "submit",
          textScaleFactor: 0.9,
          style: TextStyle(
            color: getMateGold(),
            fontFamily: "ubuntur",
            fontSize: 20
          ),
        )
      )
    );
  }




  @override
  void initState() {

    print(oc.total);
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _otp = TextEditingController();

  GeoCode geoCode = GeoCode();
}