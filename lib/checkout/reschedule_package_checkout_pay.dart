import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/checkout/done.dart';
import 'package:hair/colors.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/handle_notification.dart';
import 'package:hair/home/my_orders_in_queue.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PackageRescheduleOrderPreview extends StatefulWidget
{
  OrderClass oc;

  PackageRescheduleOrderPreview(this.oc);

  _PackageRescheduleOrderPreview createState()=> _PackageRescheduleOrderPreview(oc);
}

class _PackageRescheduleOrderPreview extends State<PackageRescheduleOrderPreview>
{


  OrderClass oc;

  _PackageRescheduleOrderPreview(this.oc);

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MyOrdersInQueue(oc)));

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
              backgroundColor: Colors.white,
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
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getProductCount(),


//                       StreamBuilder(
//                         stream: FirebaseFirestore.instance.collection("packages").doc(oc.vendorid).collection("package").snapshots(),
//                         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//
//                           if(snapshot.hasData)
//                           {
//                             if(snapshot.data!.size != 0)
//                             {
//                               return SingleChildScrollView(
//                                   physics: new BouncingScrollPhysics(),
//                                   child: Column(
//                                     children: snapshot.data!.docs.map((e) {
//
//                                       print("ddssd  ${oc.serviceid[0]}");
//                                       print("ddssd  ${e.data()['packageid']}");
// ''
//     '/'
//     ''
//                                       if(oc.serviceid[0] == e.data()['packageid'])
//                                       {
//                                         // total = total + double.parse(e.data()['price']);
//                                         // e.data()['discountavailable'] == "true" ? discount = discount + double.parse(e.data()['discount']) : discount = 0;
//                                         // totalamount = total - discount;
//
//                                         return getProductListTiles(e.data());
//                                       }
//                                       else{
//                                         return Container();
//                                       }
//
//                                       return Container();
//
//                                     }).toList(),
//                                   )
//                               );
//                             }
//                             else{
//                               return Container();
//                             }
//                           }
//                           else{
//                             return Container();
//                           }
//                         },
//
//                       ),
                        //  getProductListTiles(),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: getPackageList(),
                        ),


                        SizedBox(height: 20),

                        Container(
                          margin: EdgeInsets.all(15),
                          child: Text(
                            "Summary",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getBlackMate(),
                              fontSize: 20,
                              fontFamily: "ubuntub",
                            ),
                          ),
                        ),

                        getOtherData(),

                        SizedBox(height: 20),

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
                        text: oc.paymentstatus == "complete" ? 'reschedule' : 'pay',
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

      child: Column(
        children: [
          Row(
            children: [
              Expanded(

                  child: Text(
                    "Date",
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
                "${oc.selecteddate}",
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
                    "Start Time",
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
                "${DateFormat("HH : mm").parse(oc.starttime).hour} : "
                    "${DateFormat("HH : mm").parse(oc.starttime).minute == 0 ? "00" : DateFormat("HH : mm").parse(oc.starttime).minute}",
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

    //print("Ddsds ${oc.paymentstatus}");

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if(oc.servicetype == "package") {

      oc.serviceid.forEach((element) {
        FirebaseFirestore.instance.collection("packages").doc(oc.vendorid)
            .collection("package").doc(element).get()
            .then((value) {
          setState(() {
            total = total + double.parse(value.data()!['price']);
            value.data()!['discounton'] == "true"
                ? discount = discount + double.parse(value.data()!['discount'])
                : discount = 0;
            totalamount = value.data()!['discounton'] == "true" ?
            double.parse(value.data()!['price']) -
                double.parse(value.data()!['discount']) + totalamount :
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

        if (key1.compareTo(start) < 0) {
          oc.starttime = key;
        }
      });
    }
    else{


      oc.serviceid.forEach((element) {
        FirebaseFirestore.instance.collection("services").doc(oc.vendorid)
            .collection("service").doc(element).get()
            .then((value) {
          setState(() {
            total = total + double.parse(value.data()!['price']);
            value.data()!['discountavailable'] == "true"
                ? discount = discount + double.parse(value.data()!['discount'])
                : discount = 0;
            totalamount = value.data()!['discountavailable'] == "true" ?
            double.parse(value.data()!['price']) -
                double.parse(value.data()!['discount']) + totalamount :
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

        if (key1.compareTo(start) < 0) {
          oc.starttime = key;
        }
      });
    }

    super.initState();
  }


  void openCheckout() async {

    if(oc.paymentstatus == "complete")
    {
      _handlePaymentSuccessWithoutPay();
    }
    else {
      oc.bookeService().whenComplete(() {
        oc.createOrderDoc().whenComplete(() {
          oc.placeMyOrder().whenComplete(() {
            var options = {
              'key': 'rzp_test_ZwJDmje5nJwYe9',
              'amount': (totalamount * 100),
              'name': 'Acme Corp.',
              'description': 'Fine T-Shirt',
              'retry': {'enabled': true, 'max_count': 1},
              'send_sms_hash': true,
              'prefill': {
                'contact': '8888888888',
                'email': 'test@razorpay.com'
              },
              'external': {
                'wallets': ['paytm']
              }
            };

            try {
              _razorpay.open(options);
            } catch (e) {
              debugPrint('Error: e');
            }
          }).catchError((onError) {
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
        }).catchError((onError) {
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
        sendNotifications("reshedule","reshedule for you on ${oc.selecteddate}","reshedule","extra",oc.vendorid,oc.userid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BookedDone(oc,"rpcp")));

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

  void _handlePaymentSuccessWithoutPay() {

    oc.servicestatus = "booked";
    oc.paymentstatus = "complete";


    oc.afterPaymentReschedule().whenComplete((){

      oc.afterPaymentToMyOrderReschedule().whenComplete((){
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

        sendNotifications("reshedule","reshedule for you on ${oc.selecteddate}","reshedule","extra",oc.vendorid,oc.userid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BookedDone(oc,"rpcp")));

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


  Widget getPackageList()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Package services",
          textScaleFactor: 0.9,
          style: TextStyle(

            color: getBlackMate(),

            fontFamily: "ubuntur",
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 20),

        StreamBuilder(
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
                    return getPackageListWidget(e);
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
        )
      ],
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


  double totalamount = 0;
  double total = 0;
  double discount = 0;
  double tax = 0;

}