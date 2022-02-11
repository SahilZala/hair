import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/checkout/reschedule_package_checkout.dart';
import 'package:hair/checkout/service_order_reschedule.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/get_near_by_salon.dart';
import 'package:hair/handle_notification.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyOrdersInQueue extends StatefulWidget
{
  OrderClass oc;
  _MyOrderInQueue createState ()=> _MyOrderInQueue(oc);

  MyOrdersInQueue(this.oc);
}

class _MyOrderInQueue extends State<MyOrdersInQueue>
{
  OrderClass oc;

  _MyOrderInQueue(this.oc);



  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => NewUserHome()));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: getBlackMate()
                    ),

                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "${DateFormat('EEEE').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate))}, ${DateFormat('dd - MM - yyyy').parse(oc.selecteddate).day} ${DateFormat('MMMM').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate)).substring(0,3)} ${DateFormat('yyyy').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate))} at ${DateFormat('hh : mm').parse(oc.starttime).hour} : ${DateFormat('hh : mm').parse(oc.starttime).minute.toString().length == 1 ? DateFormat('hh : mm').parse(oc.starttime).minute.toString()+"0" : DateFormat('hh : mm').parse(oc.starttime).minute.toString()}",
                            style: TextStyle(
                                color: getLightGrey1(),
                                fontSize: 26,
                                fontFamily: "ubuntub"
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15
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


                        SizedBox(
                            height: 15
                        ),

                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: getMateBlue(),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Text(
                                  "${oc.servicestatus}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "ubuntur"
                                  ),
                                )
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: getMateBlue(),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Text(
                                  "${oc.serviceplace}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "ubuntur"
                                  ),
                                )
                            ),
                          ],
                        ),


                        SizedBox(height: 20,),

                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("business").doc(oc.vendorid).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if(snapshot.hasData)
                            {
                              if(snapshot.data != null)
                              {
                                Map<String, dynamic>? salondata = snapshot.data?.data();
                                return Container(
                                  width: MediaQuery.of(context).size.width,

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${salondata!['businessName'].toString().toUpperCase()}",
                                        style: TextStyle(
                                            color: getLightGrey1(),
                                            fontFamily: "ubuntub",
                                            fontSize: 18
                                        ),
                                      ),

                                      SizedBox(
                                          height: 10
                                      ),

                                      FutureBuilder(
                                        future: GeoCode().reverseGeocoding(latitude: double.parse(salondata['lat'].toString()), longitude: double.parse(salondata['log'].toString())),
                                        builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
                                          if(snapshot.data != null)
                                          {
                                            return Text(
                                              "${snapshot.data!.streetAddress}, ${snapshot.data!.region}, ${snapshot.data!.postal}, ${snapshot.data!.countryName}",
                                              style: TextStyle(
                                                  color: getLightGrey1(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 15
                                              ),
                                            );
                                          }
                                          else{
                                            return Text(
                                              "salon address",
                                              style: TextStyle(
                                                  color: getLightGrey1(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 15
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
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
                        ),


                        SizedBox(
                          height: 20
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        decoration:BoxDecoration(
                                          color: getGrey(),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          color: getLightGrey1(),
                                        )
                                      ),

                                      SizedBox(
                                          height: 10
                                      ),

                                      Text(
                                          "Locate",
                                          style: TextStyle(
                                              color: getLightGrey1(),
                                              fontFamily: "ubuntur"
                                          )
                                      )
                                    ],
                                  ),


                                ],
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  print(oc.servicetype);

                                  if(oc.serviceplace == 'at salon') {
                                    if (oc.servicetype == 'package') {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              PackageServiceReschedule(
                                                  oc.serviceid[0], oc.vendorid,
                                                  oc)));
                                    }
                                    else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              SalonOrderReschedule(
                                                  oc.servicetype, oc.gender,
                                                  oc.vendorid, oc.serviceid,
                                                  oc)));
                                    }
                                  }

                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(15),
                                            decoration:BoxDecoration(
                                              color: getGrey(),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: getLightGrey1(),
                                            )
                                        ),

                                        SizedBox(
                                            height: 10
                                        ),

                                        Text(
                                            "Resheduled",
                                            style: TextStyle(
                                                color: getLightGrey1(),
                                                fontFamily: "ubuntur"
                                            )
                                        )
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ),


                            Expanded(
                              child: GestureDetector(
                                onTap: (){

                                  showDialog(context: context, builder: (_) => CupertinoAlertDialog(
                                    title: Text("cancel?",
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                        fontFamily: "ubuntur",
                                        fontSize: 20,
                                        color: getBlackMate(),
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: (){
                                          cancelOrder(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("YES"),
                                        textStyle: TextStyle(
                                            fontFamily: "ubuntur",
                                            color: getMateBlue()
                                        ),
                                      ),

                                      CupertinoDialogAction(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text("NO"),
                                        textStyle: TextStyle(
                                            fontFamily: "ubuntur",
                                            color: getMateRed()
                                        ),
                                      ),
                                    ],
                                  )
                                  );

                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(15),
                                            decoration:BoxDecoration(
                                              color: getGrey(),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.cancel,
                                              color: getLightGrey1(),
                                            )
                                        ),

                                        SizedBox(
                                            height: 10
                                        ),

                                        Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: getLightGrey1(),
                                                fontFamily: "ubuntur"
                                            )
                                        )
                                      ],
                                    ),


                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),




                      ],
                    )
                  ),



                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                        "Services",
                      style: TextStyle(
                        color: getBlackMate(),

                        fontFamily: "ubuntub",
                        fontSize: 20,

                      ),
                    ),
                  ),




                  oc.servicetype == "service" ? StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

                      if(snapshot.hasData)
                      {
                        if(snapshot.data!.size != 0)
                        {
                          return Column(
                            children: snapshot.data!.docs.map((e) {


                              if(oc.serviceid.contains(e.data()['serviceid'].toString()))
                              {
                                // total = total + double.parse(e.data()['price']);
                                // e.data()['discountavailable'] == "true" ? discount = discount + double.parse(e.data()['discount']) : discount = 0;
                                // totalamount = total - discount;

                                return getProductListTiles(e.data());
                              }
                              else{
                                return Container();
                              }

                            }).toList(),
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
                  ) : StreamBuilder(
                    stream: FirebaseFirestore
                        .instance
                        .collection("packages")
                        .doc(oc.vendorid).collection("package").doc(oc.serviceid[0]).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data != null)
                        {
                          List pdata = snapshot.data['service'];

                          print("pdata =  ${pdata}");

                          return Column(
                            children: pdata.map((e){
                              return getPackageListWidgetNew(e);
                            }).toList(),
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
                  ),


                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    height: 2,
                    color: getLightGrey1(),
                    margin: EdgeInsets.all(15),
                  ),


                  getOtherData(),


                  Container(
                    height: 2,
                    color: getLightGrey1(),
                    margin: EdgeInsets.all(15),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(

                      children: [
                        Expanded(
                          child: Text(
                            "OTP",
                            style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20,
                                fontFamily: "ubuntub"
                            ),

                          ),
                        ),


                        Text(
                          "$code",
                          style: TextStyle(
                            color: getMateGold(),
                            fontFamily: "ubuntub",
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(
                    height: 2,
                    color: getLightGrey1(),
                    margin: EdgeInsets.all(15),
                  ),




                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(

                          children: [
                            Expanded(
                              child: Text(
                                  "Taxes",
                                style: TextStyle(
                                  color: getGrey(),
                                  fontSize: 15,
                                    fontFamily: "ubuntur"
                                ),

                              ),
                            ),

                            Text(
                              "₹${oc.tax}",
                              style: TextStyle(
                                color: getGrey(),
                                fontSize: 15,
                                  fontFamily: "ubuntur"
                              ),
                            )
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(

                          children: [
                            Expanded(
                              child: Text(
                                "Discount",
                                style: TextStyle(
                                  color: getGrey(),
                                  fontSize: 15,
                                    fontFamily: "ubuntur"
                                ),

                              ),
                            ),

                            Text(
                              "₹${oc.disount}",
                              style: TextStyle(
                                color: getGrey(),
                                fontSize: 15,
                                  fontFamily: "ubuntur"
                              ),
                            )
                          ],
                        ),


                        SizedBox(
                          height: 10,
                        ),
                        Row(

                          children: [
                            Expanded(
                              child: Text(
                                "Total",
                                style: TextStyle(
                                  color: getBlackMate(),
                                  fontSize: 20,
                                  fontFamily: "ubuntub"
                                ),

                              ),
                            ),

                            Text(
                              "₹${oc.finaltotal}",
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontSize: 20,
                                  fontFamily: "ubuntub"
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),




                  // Padding(
                  //   padding: EdgeInsets.all(15),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //
                  //     children: [
                  //
                  //
                  //
                  //     //  getSliderWidget(),
                  //       SizedBox(
                  //         height: 20,
                  //       ),
                  //       //getSalonData(),
                  //       oc.servicetype == "service" ? getSelectedServiceList() : StreamBuilder(
                  //         stream: FirebaseFirestore
                  //             .instance
                  //             .collection("packages")
                  //             .doc(oc.vendorid).collection("package").doc(oc.serviceid[0]).snapshots(),
                  //         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //           if(snapshot.hasData){
                  //             if(snapshot.data != null)
                  //             {
                  //               List pdata = snapshot.data['service'];
                  //
                  //               print("pdata =  ${pdata}");
                  //
                  //               return Column(
                  //                 children: pdata.map((e){
                  //                   return getPackageListWidget(e);
                  //                 }).toList(),
                  //               );
                  //
                  //             }
                  //             else{
                  //               return Container();
                  //             }
                  //           }
                  //           else{
                  //             return Container();
                  //           }
                  //
                  //         },
                  //       ),
                  //
                  //       SizedBox(
                  //         height: 30,
                  //       ),
                  //
                  //
                  //       Container(
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width,
                  //         padding: EdgeInsets.all(15),
                  //         decoration: BoxDecoration(
                  //           color: getBlackMate(),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Text(
                  //           "${oc.servicestatus}",
                  //           style: TextStyle(
                  //             color: getMateGold(),
                  //             fontFamily: "ubuntur",
                  //             fontSize: 18
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              )
            ),

              appBar: AppBar(
                backgroundColor: getBlackMate(),
                elevation: 0,
                title: Text(
                  "My Order",
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
                    _onWillPop();
                    },
                ),
              )
          ),
      ),
    );
  }

  Widget getPackageListWidgetNew(String serviceid)
  {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").doc(serviceid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          if(snapshot.data != null)
          {
            //  return getProductListTiles(snapshot.data!.data() as Map);
            return Container(
              margin: EdgeInsets.fromLTRB(15,5,15,5),
              decoration: BoxDecoration(
                  color: getLightGrey(),
                  borderRadius: BorderRadius.circular(10)
              ),

              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: getBlackMate(),
                  child: Text(
                    "${snapshot.data!['servicename'][0].toString().toUpperCase()}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Text(
                    "₹ ${snapshot.data!['price']}  /-",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getMateGold(),
                        fontFamily: "ubuntub",
                        fontSize: 20
                    ),
                  ),
                ) ,

                title: Text("${snapshot.data!['servicename'].toString().toUpperCase()}",
                  textScaleFactor: 0.9,
                  style: TextStyle(color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ),),
                subtitle: Text(
                  "${snapshot.data!['serviceduration']} Minutes",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      fontFamily: "ubuntur",
                      fontSize: 13
                  ),
                ),
              ),
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

  Widget getSliderWidget()
  {
    return StreamBuilder(
      stream: getSalonGallaryImage(oc.vendorid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
        if(snapshot.hasData){

          if(snapshot.data?.docs.toList().isNotEmpty == true) {

            var imgList = snapshot.data?.docs.toList();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16 / 8,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, s) {
                      // setState(() {
                      //   _current = index;
                      // });
                    }
                ),
                items: imgList!.map((item) => getSliderItem(item['url'])).toList(),

              ),
            );

            // return Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 125,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Colors.grey,
            //       image: DecorationImage(
            //           image: NetworkImage(
            //             snapshot.data?.docs.toList()[0]['url'],
            //           ),
            //           fit: BoxFit.fill
            //       )
            //   ),
            // );
          }
          else{
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                      ),
                      fit: BoxFit.cover
                  )
              ),
            );
          }


        }
        else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                    ),
                    fit: BoxFit.cover
                )
            ),
          );
        }
      },
    );
  }

  Widget getSliderItem(String url) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                url
            ),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  
  Widget getSalonData()
  {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("business").doc(oc.vendorid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          if(snapshot.data != null)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${snapshot.data!.data()!['businessName']}",
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 25

                  ),
                ),


                SizedBox(height: 10,),

                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemSize: 20,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: getMateGold(),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),

                    Text(
                      "0.0",
                      style: TextStyle(
                        color: getMateGold(),
                        fontSize: 20,
                        fontFamily: "ubuntub",

                      ),
                    ),
                  ],
                ),

                SizedBox(height:10,),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: getMateGold(),
                      size: 15,
                    ),

                    SizedBox(
                      width: 5,
                    ),

                    Text(
                      "${snapshot.data!.data()!['address']}",
                      style: TextStyle(
                        color: getMateGold(),
                        fontSize: 15,
                        fontFamily: "ubuntur"
                      ),
                    )

                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: getLightGrey1(),
                ),

                SizedBox(
                  height: 15,
                ),

                Text(
                  "End Your Service",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 22,
                  ),
                ),

                SizedBox(height: 10,),

                Text(
                  "give otp to vendor",
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntur",
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 15,),

                Text(
                  "$code",
                  style: TextStyle(
                    color: getMateGold(),
                    fontFamily: "ubuntub",
                    fontSize: 25,
                  ),
                ),

                SizedBox(height: 15,),

                Text(
                    "start time - ${oc.starttime}",
                  style: TextStyle(
                      color: getMateGold(),
                      fontSize: 15,
                      fontFamily: "ubuntur"
                  ),
                ),

                SizedBox(
                  height: 10,

                ),

                Text(
                    "servcie date - ${oc.selecteddate}",
                  style: TextStyle(
                    color: getMateGold(),
                    fontSize: 15,
                    fontFamily: "ubuntur"
                  ),
                ),


                // SizedBox(height: 10,),
                //
                // Text(
                //   "seat number - ${oc.seatnumber}",
                //   style: TextStyle(
                //       color: getMateGold(),
                //       fontSize: 15,
                //       fontFamily: "ubuntur"
                //   ),
                // ),

                SizedBox(
                  height: 10,

                ),


                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: getLightGrey1(),
                ),



                SizedBox(
                  height: 15,
                ),

              ],
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


  Widget getSelectedServiceList()
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "services",
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                ),
              ),
            ),

            Text(
              "price",
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntur",
                fontSize: 20,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),
        
        Column(
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
                              style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntur",
                                fontSize: 15
                              ),
                            )
                        ),
                        Text(
                          "Rs ${snapshot.data?.data()!['price']} /-",
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
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "+ Rs ${oc.tax} /-",
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
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "- Rs ${oc.disount} /-",
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
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "Rs ${oc.finaltotal} /-",
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
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "${oc.totalduration} Minutes",
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 15
              ),
            )
          ],
        ),


        Text(
          "give otp to vendor",
          style: TextStyle(
            color: getBlackMate(),
            fontFamily: "ubuntur",
            fontSize: 15,
          ),
        ),





      ],
    );
  }



  Widget getProductListTiles(Map servicedata){
    return Container(
      margin: EdgeInsets.fromLTRB(15,5,15,5),
      decoration: BoxDecoration(
          color: getLightGrey(),
          borderRadius: BorderRadius.circular(10)
      ),

      child: ListTile(


        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              servicedata['discountavailable'] == 'true' ? "₹ ${int.parse(servicedata['price'])-int.parse(servicedata['discount'])}" : "₹ ${int.parse(servicedata['price'])}",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getMateGold(),
                  fontFamily: "ubuntub",
                  fontSize: 20
              ),
            ),

            SizedBox(height: 5,),
            Container(



              child: servicedata['discountavailable'] == 'true' ? Wrap(
                children: [

                  Text(
                    "₹ ${servicedata['price']}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: "ubuntur",
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough
                    ),
                  )
                ],
              ) : SizedBox(),
            ),
          ],
        ) ,
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            "${servicedata['servicetype'][0]}",
            textScaleFactor: 0.9,
            style: TextStyle(
              color: getBlackMate(),
              fontFamily: "ubuntub",

            ),
          ),
          foregroundColor: getBlackMate(),
        ),
        title: Text(
          //val.service_category
          "${servicedata['servicename']}",
          textScaleFactor: 0.9,
          style: TextStyle(
              color: getBlackMate(),
              fontFamily: "ubuntub",
              fontSize: 15
          ),
        ),

        subtitle: Text(
          //val.service_category
          "${servicedata['servicetype']}",
          textScaleFactor: 0.9,
          style: TextStyle(
              fontFamily: "ubuntur",
              fontSize: 13
          ),
        ),
      ),
    );
  }

  Widget getOtherData()
  {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),

      child: Row(
        children: [

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total duration",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ubuntur",
                    fontSize: 16,
                  ),
                ),

                //SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child: Text(
                    "${oc.totalduration} Minutes",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),




          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Gender",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ubuntur",
                    fontSize: 16,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child: Text(
                    "${oc.gender}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),



          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Text(
          //         "Seat no",
          //         textScaleFactor: 0.9,
          //         style: TextStyle(
          //           color: Colors.grey,
          //           fontFamily: "ubuntur",
          //           fontSize: 16,
          //         ),
          //       ),
          //
          //
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(0,10,0,0),
          //         child: Text(
          //           "${oc.seatnumber}",
          //           textScaleFactor: 0.9,
          //           style: TextStyle(
          //             color: getBlackMate(),
          //             fontFamily: "ubuntub",
          //             fontS+ize: 20,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),


        ],
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),

      child: Column(
        children: [

          Row(
            children: [
              Expanded(

                  child: Text(
                    "Total duration",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  )
              ),

              SizedBox(width: 10),
              Text(
                "${oc.totalduration} Minutes",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),

          SizedBox(
            height: 15,
          ),


          Row(
            children: [
              Expanded(

                  child: Text(
                    "Gender",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  )
              ),

              SizedBox(width: 10),
              Text(
                "${oc.gender}",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            children: [
              Expanded(

                  child: Text(
                    "Seat no",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  )
              ),

              SizedBox(width: 10),
              Text(
                "${oc.seatnumber}",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),


        ],
      ),
    );
  }

  void cancelOrder(c){

    print(oc.data);
    oc.updateOrderStatusCancel(oc.orderid,oc.vendorid,oc.userid,"user").then((value){

      print(oc.orderid);
      print(oc.userid);
      oc.updateOrderStatusAfterDoneCancel(oc.orderid,oc.vendorid, oc.userid,"user").then((value){


        sendNotifications("canceld","order canceled on ${oc.selecteddate}","canceld","extra",oc.vendorid,oc.userid);

        showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Order Canceld",
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15
              ),
            )
        );


        _onWillPop();
      });

    });
  }


  @override
  void initState() {

    var rng = new Random();
    code = rng.nextInt(900000) + 100000;

    //print(oc.data);

    oc.setOtpToFirebase(oc.orderid,oc.vendorid,"$code");

    super.initState();
  }

  int code = 0;
}