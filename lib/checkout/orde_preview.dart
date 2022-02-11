import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/checkout/done.dart';
import 'package:hair/colors.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/handle_notification.dart';
import 'package:hair/home/salon_details.dart';
import 'package:hair/home/service_selection.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderPreview extends StatefulWidget
{
  OrderClass oc;
  String comes;
  String type;
  OrderPreview(this.oc,this.type,this.comes);

  _OrderPreview createState()=> _OrderPreview(oc,type,comes);
}

class _OrderPreview extends State<OrderPreview>
{


  OrderClass oc;
  String comes;
  String type;
  
  _OrderPreview(this.oc,this.type,this.comes);

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  Future<bool> _onWillPop() async{

    if(type == "single") {
      print(oc.seattype);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ServiceSelection(oc.seattype, servicetype,serviceCat ,oc.vendorid, oc.serviceid[0],comes)));
    }
    if(comes == "ahb" && type == "multi")
    {
        print(";negnreogjeg $comes");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            ServiceSelection(oc.seattype, servicetype,serviceCat ,oc.vendorid, oc.serviceid[0],comes)));
    }
    if(comes == "gsco" && type == "multi")
    {
      print(";negnreogjeg $comes");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          SalonDetails(oc.vendorid)));
    }
    if(comes == "psc" && type == "multi")
    {
      print(";negnreogjeg $comes");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          SalonDetails(oc.vendorid)));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(

          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: getLightGrey1(),
            elevation: 0,
            title: Text(
                "Payments",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur"
                )
            ),

            leading: IconButton(
              icon: Icon(Icons.keyboard_backspace_rounded,color: getBlackMate(),),
              onPressed: () {
                _onWillPop();
                },
            ),
          ),
          body: Stack(
            children: [

              Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: getLightGrey1(),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(360))
                ),
              ),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Container(
                      child: Text(
                        "${DateFormat('EEEE').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate))}, ${DateFormat('dd - MM - yyyy').parse(oc.selecteddate).day} ${DateFormat('MMMM').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate)).substring(0,3)} ${DateFormat('yyyy').format(DateFormat('dd - MM - yyyy').parse(oc.selecteddate))} at ${DateFormat('hh : mm').parse(oc.starttime).hour} : ${DateFormat('hh : mm').parse(oc.starttime).minute.toString().length == 1 ? DateFormat('hh : mm').parse(oc.starttime).minute.toString()+"0" : DateFormat('hh : mm').parse(oc.starttime).minute.toString()}",
                        style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 26,
                          fontFamily: "ubuntub"
                        ),
                      ),
                      padding: EdgeInsets.all(15),
                    ),

                    Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
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


                    SizedBox(height: 15,),


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
                              margin: EdgeInsets.all(15),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${salondata!['businessName'].toString().toUpperCase()}",
                                    style: TextStyle(
                                      color: getBlackMate(),
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
                                              color: getBlackMate(),
                                              fontFamily: "ubuntur",
                                              fontSize: 15
                                          ),
                                        );
                                      }
                                      else{
                                        return Text(
                                          "salon address",
                                          style: TextStyle(
                                              color: getBlackMate(),
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

                    getProductCount(),


                    oc.servicetype == "service" ?
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

                        if(snapshot.hasData)
                        {
                          if(snapshot.data!.size != 0)
                          {
                            return SingleChildScrollView(
                                physics: new BouncingScrollPhysics(),
                                child: Column(
                                  children: snapshot.data!.docs.map((e) {




                                    if(oc.serviceid.contains(e.data()['serviceid'].toString()))
                                    {
                                      // total = total + double.parse(e.data()['price']);
                                      // e.data()['discountavailable'] == "true" ? discount = discount + double.parse(e.data()['discount']) : discount = 0;
                                      // totalamount = total - discount;

                                      serviceCat = e.data()['servicecategory'];
                                      servicetype = e.data()['servicetype'];
                                      return getProductListTiles(e.data());
                                    }
                                    else{
                                      return Container();
                                    }

                                  }).toList(),
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

                    ) : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: StreamBuilder(
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
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0,5,0,5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: getBlackMate(),
                                        child: Text(
                                          "${snapshot.data!['packagename'][0].toString().toUpperCase()}",
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            color: getBlackMate(),
                                            fontFamily: "ubuntub",
                                          ),
                                        ),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data['discounton'] == 'true' ? "₹ ${int.parse(snapshot.data['price'])-int.parse(snapshot.data['discount'])}" : "₹ ${int.parse(snapshot.data['price'])}",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getMateGold(),
                                                  fontFamily: "ubuntub",
                                                  fontSize: 20
                                              ),
                                            ),

                                            Text(
                                              "₹ ${snapshot.data['price']}",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: "ubuntur",
                                                  fontSize: 15,
                                                  decoration: TextDecoration.lineThrough
                                              ),
                                            )
                                          ],
                                        ),
                                      ) ,

                                      title: Text("${snapshot.data!['packagename'].toString().toUpperCase()}",
                                        textScaleFactor: 0.9,
                                        style: TextStyle(color: getBlackMate(),
                                            fontFamily: "ubuntur",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15
                                        ),),
                                      subtitle: Text(
                                        "${snapshot.data!['duration']} Minutes",
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                            fontFamily: "ubuntur",
                                            fontSize: 13
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Column(
                                  //   children: pdata.map((e){
                                  //     return getPackageListWidget(e);
                                  //   }).toList(),
                                  // ),
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
                      ),
                    ),
                  //  getProductListTiles(),



                    SizedBox(height: 10),

                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(
                        "Summary",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 22,
                          fontFamily: "ubuntub",
                        ),
                      ),
                    ),

                    getOtherData(),

                    SizedBox(height: 15),

                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text(
                        "Final",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          fontFamily: "ubuntub",
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                      ),
                    ),

                    getOrderCheckList(),


                    SizedBox(
                      height: 50,
                    )
                  ],
                )
              ),


              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: getLightGrey1(),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(15)),
                    ),

                    child: AnimatedButton(
                      text: 'pay',
                      isReverse: true,
                      selectedBackgroundColor: getMateGold(),
                      backgroundColor: getLightGrey1(),
                      selectedTextColor: getBlackMate(),
                      transitionType: TransitionType.LEFT_TOP_ROUNDER,
                      textStyle: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntur",
                        fontSize: 20/getScaleFactor(context)
                      ),
                      onPress: () {

                        openCheckout();
                        },
                    ),
                    // child: MaterialButton(
                    //   onPressed: (){
                    //
                    //   },
                    //   elevation: 0,
                    //   child: Text("pay",
                    //     style: TextStyle(
                    //       color: getBlackMate(),
                    //       fontFamily: "ubuntur",
                    //       fontSize: 20
                    //     ),
                    //   ),
                    // ),
                  )
                ],
              )

            ],
          )
        ),
      ),
    );
  }

  Widget getPackageListWidget(String serviceid)
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
              margin: EdgeInsets.fromLTRB(0,5,0,5),
              decoration: BoxDecoration(
                  color: Colors.white,
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


  Widget getProductCount()
  {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(10),

          child: Text(
            "${oc.serviceid.length} items",
            textScaleFactor: 0.9,
            style: TextStyle(
              color: getBlackMate(),
              fontFamily: "ubuntur",
              fontSize: 15
            ),
          )
        )
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



  Widget getOrderCheckList()
  {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),

      child: Column(
        children: [

          Row(
            children: [
              Expanded(

                child: Text(
                  "Order Amount",
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
                "Rs. $total /-",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),

          SizedBox(height: 15,),

          Row(
            children: [
              Expanded(

                  child: Text(
                    "Tax Amount",
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
                "Rs. $tax /-",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),

          SizedBox(height: 15,),

          Row(
            children: [
              Expanded(

                  child: Text(
                    "Discount",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  )
              ),

              SizedBox(width: 15),
              Text(
                "Rs. $discount /-",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 16,
                ),
              )
            ],
          ),


          SizedBox(height: 30,),


          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 5.0,
            dashColor: getBlackMate(),
            //dashGradient: [Colors.red, Colors.blue],
            dashRadius: 0.0,
            dashGapLength: 4.0,
            dashGapColor: Colors.transparent,
            //dashGapGradient: [Colors.red, Colors.blue],
            dashGapRadius: 0.0,
          ),


          SizedBox(height: 30,),


          Row(
            children: [
              Expanded(

                  child: Text(
                    "Total",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 20,
                    ),
                  )
              ),

              SizedBox(width: 15),
              Text(
                "Rs. $totalamount /-",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getMateGold(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                ),
              )
            ],
          ),



        ],
      )
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



          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Seat no",
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
                    "${oc.seatnumber}",
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

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {

    oc.servicetype == "service" ? getServiceStartup() : getPackageStartup();

    super.initState();
  }

  void getPackageStartup()
  {

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    oc.serviceid.forEach((element) {
      FirebaseFirestore.instance.collection("packages").doc(oc.vendorid).collection("package").doc(element).get().then((value){

        setState(() {
          total = total + double.parse(value.data()!['price']);
          value.data()!['discounton'] == "true" ? discount = discount + double.parse(value.data()!['discount']) : discount = 0;
          totalamount =  value.data()!['discounton'] == "true" ?
          double.parse(value.data()!['price']) - double.parse(value.data()!['discount']) + totalamount :
          double.parse(value.data()!['price']) + totalamount;

          oc.total = total.toString();
          oc.finaltotal = totalamount.toString();
          oc.disount = discount.toString();
          oc.tax = tax.toString();

        });




      });
    });


    total = total + tax;

    oc.data.forEach((key, value) {

      DateTime key1 = DateFormat("HH : mm").parse(key);

      DateTime start = DateFormat("HH : mm").parse(oc.starttime);

      if(key1.compareTo(start) < 0)
      {
        oc.starttime = key;
      }
    });

  }

  void getServiceStartup(){

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    oc.serviceid.forEach((element) {
      FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").doc(element).get().then((value){

        setState(() {
          total = total + double.parse(value.data()!['price']);
          value.data()!['discountavailable'] == "true" ? discount = discount + double.parse(value.data()!['discount']) : discount = 0;
          totalamount =  value.data()!['discountavailable'] == "true" ?
          double.parse(value.data()!['price']) - double.parse(value.data()!['discount']) + totalamount :
          double.parse(value.data()!['price']) + totalamount;

          oc.total = total.toString();
          oc.finaltotal = totalamount.toString();
          oc.disount = discount.toString();
          oc.tax = tax.toString();

        });




      });
    });


    total = total + tax;

    oc.data.forEach((key, value) {

      DateTime key1 = DateFormat("HH : mm").parse(key);

      DateTime start = DateFormat("HH : mm").parse(oc.starttime);

      if(key1.compareTo(start) < 0)
      {
        oc.starttime = key;
      }
    });

  }

  void openCheckout() async {

    oc.bookeService().whenComplete((){

      oc.createOrderDoc().whenComplete(() {

        oc.placeMyOrder().whenComplete((){

          var options = {
            'key': 'rzp_test_ZwJDmje5nJwYe9',
            'amount': (totalamount*100),
            'name': 'Acme Corp.',
            'description': 'Fine T-Shirt',
            'retry': {'enabled': true, 'max_count': 1},
            'send_sms_hash': true,
            'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
            'external': {
              'wallets': ['paytm']
            }
          };

          try {
            _razorpay.open(options);
          } catch (e) {
            debugPrint('Error: e');
          }
        }).catchError((onError){
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: onError.toString(),
                textStyle: TextStyle(
                    fontFamily: "ubuntub",
                    color: Colors.white,
                    fontSize: 15
                ),
              )
          );
        });
      }).catchError((onError){
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: onError.toString(),
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    oc.servicestatus = "booked";
    oc.paymentstatus = "complete";


    oc.afterPayment().whenComplete((){

      oc.afterPaymentToMyOrder().whenComplete((){
        showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "SUCCESS",
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15/getScaleFactor(context)
              ),
            )
        );

        oc.removeCart(oc.vendorid).then((value){
          print("removed");
        });

        sendNotifications("booking","booking for you on ${oc.selecteddate}","booking","extra",oc.vendorid,oc.userid);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BookedDone(oc,"op")));


      }).catchError((onError){
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: onError.toString(),
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15/getScaleFactor(context)
              ),
            )
        );
      });
    }).catchError((onError){
      showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "PLease contact to vendor",
            textStyle: TextStyle(
                fontFamily: "ubuntub",
                color: Colors.white,
                fontSize: 15/getScaleFactor(context)
            ),
          )
      );
    });

    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {

    oc.servicestatus = "canceld";
    oc.paymentstatus = "fail";


    oc.afterPayment().whenComplete((){

      oc.afterPaymentToMyOrder().whenComplete((){

        showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: "Payment failed",
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15/getScaleFactor(context)
              ),
            )
        );


      }).catchError((onError){
        showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: onError.toString(),
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15/getScaleFactor(context)
              ),
            )
        );
      });
    }).catchError((onError){
      showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "PLease contact to vendor",
            textStyle: TextStyle(
                fontFamily: "ubuntub",
                color: Colors.white,
                fontSize: 15/getScaleFactor(context)
            ),
          )
      );
    });



    Navigator.pop(context);

    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: "EXTERNAL_WALLET: " + response.walletName!,
          textStyle: TextStyle(
              fontFamily: "ubuntub",
              color: Colors.white,
              fontSize: 15/getScaleFactor(context)
          ),
        )
    );


    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  double totalamount = 0;
  double total = 0;
  double discount = 0;
  double tax = 0;
  String serviceCat = "";
  String servicetype = "";
}