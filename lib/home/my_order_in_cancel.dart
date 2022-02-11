import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/colors.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:intl/intl.dart';

class CanceledOrders extends StatefulWidget
{
  OrderClass oc;

  _CanceledOrders createState ()=> _CanceledOrders(oc);

  CanceledOrders(this.oc);
}

class _CanceledOrders extends State<CanceledOrders>
{
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

                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: getMateRed(),
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
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Container(
                                //               padding: EdgeInsets.all(15),
                                //               decoration:BoxDecoration(
                                //                 color: getGrey(),
                                //                 borderRadius: BorderRadius.circular(15),
                                //               ),
                                //               child: Icon(
                                //                 Icons.location_on_rounded,
                                //                 color: getLightGrey1(),
                                //               )
                                //           ),
                                //
                                //           SizedBox(
                                //               height: 10
                                //           ),
                                //
                                //           Text(
                                //               "Locate",
                                //               style: TextStyle(
                                //                   color: getLightGrey1(),
                                //                   fontFamily: "ubuntur"
                                //               )
                                //           )
                                //         ],
                                //       ),
                                //
                                //
                                //     ],
                                //   ),
                                // ),

                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Container(
                                //               padding: EdgeInsets.all(15),
                                //               decoration:BoxDecoration(
                                //                 color: getGrey(),
                                //                 borderRadius: BorderRadius.circular(15),
                                //               ),
                                //               child: Icon(
                                //                 Icons.calendar_today,
                                //                 color: getLightGrey1(),
                                //               )
                                //           ),
                                //
                                //           SizedBox(
                                //               height: 10
                                //           ),
                                //
                                //           Text(
                                //               "Resheduled",
                                //               style: TextStyle(
                                //                   color: getLightGrey1(),
                                //                   fontFamily: "ubuntur"
                                //               )
                                //           )
                                //         ],
                                //       ),
                                //
                                //
                                //     ],
                                //   ),
                                // ),


                                // Expanded(
                                //   child: GestureDetector(
                                //     onTap: (){
                                //
                                //
                                //     },
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //       mainAxisAlignment: MainAxisAlignment.end,
                                //
                                //       children: [
                                //         Column(
                                //           crossAxisAlignment: CrossAxisAlignment.center,
                                //           mainAxisAlignment: MainAxisAlignment.center,
                                //           children: [
                                //             Container(
                                //                 padding: EdgeInsets.all(15),
                                //                 decoration:BoxDecoration(
                                //                   color: getGrey(),
                                //                   borderRadius: BorderRadius.circular(15),
                                //                 ),
                                //                 child: Icon(
                                //                   Icons.cancel,
                                //                   color: getLightGrey1(),
                                //                 )
                                //             ),
                                //
                                //             SizedBox(
                                //                 height: 10
                                //             ),
                                //
                                //             Text(
                                //                 "Cancel",
                                //                 style: TextStyle(
                                //                     color: getLightGrey1(),
                                //                     fontFamily: "ubuntur"
                                //                 )
                                //             )
                                //           ],
                                //         ),
                                //
                                //
                                //         SizedBox(
                                //           height: 15,
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // )
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


                    SizedBox(
                      height: 10,
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
          //             fontSize: 20,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),


        ],
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
                contentPadding: EdgeInsets.all(0),
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




  OrderClass oc;

  _CanceledOrders(this.oc);
}