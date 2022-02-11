import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/checkout/cart.dart';
import 'package:hair/checkout/orde_preview.dart';
import 'package:hair/checkout/reschedule_package_checkout_pay.dart';
import 'package:hair/checkout/time_date_selection.dart';
import 'package:hair/checkout/time_date_selection_new.dart';
import 'package:hair/colors.dart';
import 'package:hair/home/my_orders_in_queue.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SalonOrderReschedule extends StatefulWidget{

  String servicetype;
  String gender;
  String salonid;
  List<String> serviceid;

  OrderClass newoc;


  SalonOrderReschedule(this.servicetype, this.gender, this.salonid, this.serviceid,this.newoc);

  _SalonOrderReschedule createState ()=> _SalonOrderReschedule(
      this.servicetype, this.gender, this.salonid, this.serviceid,this.newoc);
}

class _SalonOrderReschedule extends State<SalonOrderReschedule>
{



  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MyOrdersInQueue(newoc)));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery
        .of(context)
        .textScaleFactor + 0.2;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                body: SingleChildScrollView(
                  physics: new BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _businessdetail != null ? getSalonContainer() : Container(),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),

                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: getBlackMate(),
                  title: Text(
                    "Hair Cut",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${totalduration} Minute",
                                      //"${_servicedata['serviceduration']} Minute",
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: getMateGold(),
                                          fontFamily: "ubuntub",
                                          fontSize: 22
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      "total duration",
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: getBlackMate(),
                                          fontFamily: "ubuntur",
                                          fontSize: 13
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15,0,15,0),
                            child: Material(
                              borderRadius: BorderRadius.circular(15),
                              child: RaisedButton(
                                color: getBlackMate(),
                                onPressed: () {
                                  if(totalduration == (selectSlot.length*10))
                                  {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoAlertDialog(
                                          title: new Text("do you want to proceed"),
                                          content: new Text("?"),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              child: Text("Yes"),
                                              onPressed: (){
                                                bookSlots(
                                                    FirebaseAuth.instance.currentUser!.uid.toString(),
                                                    _businessdetail['vendorid'].toString(),
                                                    serviceid,
                                                    newoc.seattype,
                                                    "${currentDate.day} - ${currentDate
                                                        .month} - ${currentDate.year}",
                                                    "-1",
                                                    gender,
                                                    selectSlot.firstKey().toString(),
                                                    selectSlot.lastKey().toString(),
                                                    "pending",
                                                    "$totalduration",
                                                    "${selectSlot.length}",
                                                    selectSlot
                                                );

                                                print(selectSlot.keys);
                                                // Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: Text("No"),
                                              onPressed: (){
                                                print("noondondosndosndosdnosdnosdno");
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        )
                                    );
                                  }
                                },

                                child: Text(
                                  "Pay ${totalPrice} /-",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "ubuntub",

                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ),
                          )






                        ],
                      ),

                    )
                  ],
                ),
              ),


              progressBar == 0 ? Container() : Center(child: CircularProgressIndicator()),


            ],
          )
      ),
    );
  }


  Widget getSlotsContainer(String slot, List<NewSlots> data) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),

        child: Column(
          children: [
            Text(
              "$slot : 00",
              textScaleFactor: 0.9,
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntub",
                fontSize: 23,
              ),
            ),

            SizedBox(
              height: 20,
            ),


            Wrap(
              spacing: 15,
              runSpacing: 15,
              crossAxisAlignment: WrapCrossAlignment.center,

              children: data.map((e) {

                return getTimeSlot(e);
              }).toList(),

              // children: [
              //
              //   getTimeSlot("9 : 00 AM",0),
              //   getTimeSlot("9 : 10 AM",1),
              //   getTimeSlot("9 : 20 AM",2),
              //   getTimeSlot("9 : 30 AM",1),
              //   getTimeSlot("9 : 40 AM",0),
              //   getTimeSlot("9 : 50 AM",2),
              // ],
            )

          ],
        ),
      ),
    );
  }


  Widget getTimeSlot(NewSlots e) {
    return Column(
      children: [
        Container(

          width: 85,
          alignment: Alignment.center,

          //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: e.status == 0 ? getMateBlue() : e.status == 1
                  ? getMateGold()
                  : getMateRed(), width: 2.0)
          ),
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            elevation: 0,
            color: Colors.white,
            onPressed: () {

              if(e.status == 0) {

                if (selectSlot.isNotEmpty) {

                  selectSlot.forEach((key, value) {
                    setState(() {
                      selectSlot[key]!.status = 0;
                    });
                    print("giloy = ${key}");
                  });
                  selectSlot.clear();
                }

                print(selectSlot);


                DateTime custom = DateFormat("HH : mm").parse(e.start.toString());


                _servicedata.forEach((element) {
                  for (int i = 0; i < int.parse(element['serviceduration']);
                  i = i + 10) {
                    int hour = custom.hour;

                    print("dsdsdd = ${custom}");

                    List<NewSlots>? data = slotsData[hour];

                    for (int i = 0; i < data!.length; i++) {
                      DateTime check = DateFormat("HH : mm").parse(data
                          .elementAt(i)
                          .start
                          .toString());

                      if (check.compareTo(custom) == 0) {
                        if (data
                            .elementAt(i)
                            .status == 0) {
                          selectSlot[data
                              .elementAt(i)
                              .start] = data.elementAt(i);
                        }
                        else {
                          selectSlot.clear();
                        }
                      }
                    }

                    custom = custom.add(Duration(seconds: 600));
                  }

                });


                if((selectSlot.length*10) != totalduration)
                {
                  if (selectSlot.isNotEmpty) {

                    selectSlot.forEach((key, value) {
                      setState(() {
                        selectSlot[key]!.status = 0;
                      });
                      print("giloy = ${key}");
                    });
                    selectSlot.clear();
                  }
                }




                print(selectSlot);

                selectSlot.forEach((key, value) {
                  setState(() {
                    selectSlot[key]!.status = 1;
                  });
                });
              }
              else{

                if (selectSlot.isNotEmpty) {

                  selectSlot.forEach((key, value) {
                    setState(() {
                      selectSlot[key]!.status = 0;
                    });
                    print("giloy = ${key}");
                  });
                  selectSlot.clear();
                }
              }
            },
            child: Text(
                "${DateFormat("HH : mm").parse(e.start).hour} : "
                    "${DateFormat("HH : mm").parse(e.start).minute == 0 ? "00" : DateFormat("HH : mm").parse(e.start).minute}",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 15
              ),
            ),
          ),
        ),
        // Text(
        //     "${e.seatcount}/$_seatcount"
        // ),
      ],
    );
  }

  // Widget getGenderWidget(String servicegender) {
  //   return Container(
  //     width: MediaQuery
  //         .of(context)
  //         .size
  //         .width,
  //     margin: EdgeInsets.all(0),
  //     padding: EdgeInsets.all(0),
  //
  //     child: Row(
  //       children: [
  //
  //
  //         servicegender == "male" || servicegender == "unisex" ? Row(
  //           children: [
  //
  //             Text(
  //               "male",
  //               textScaleFactor: 0.9,style: TextStyle(
  //                 color: getBlackMate(),
  //                 fontSize: 22,
  //                 fontFamily: "ubuntur"
  //             ),
  //             ),
  //
  //             Radio(
  //
  //               splashRadius: 60,
  //               focusColor: getBlackMate(),
  //               activeColor: getMateGold(),
  //               onChanged: (value) {
  //                 setState(() {
  //                   maleFemale = 1;
  //                   // _sheetSlectionCounter = 1;
  //                   _genderSelected = 1;
  //
  //                   rectifySlots(_businessdetail['vendorid'].toString(),
  //                       "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
  //                       "$_sheetSlectionCounter");
  //                 });
  //
  //
  //
  //               },
  //               groupValue: maleFemale,
  //               value: 1,
  //             ),
  //
  //
  //           ],
  //         ) : Container(),
  //
  //
  //         servicegender == "female" || servicegender == "unisex" ? Row(
  //           children: [
  //
  //             Text(
  //               "female",
  //               textScaleFactor: 0.9,style: TextStyle(
  //                 color: getBlackMate(),
  //                 fontSize: 22,
  //                 fontFamily: "ubuntur"
  //             ),
  //             ),
  //
  //             Radio(
  //
  //               splashRadius: 60,
  //               focusColor: getBlackMate(),
  //               activeColor: getMateGold(),
  //               onChanged: (value) {
  //                 setState(() {
  //                   maleFemale = 0;
  //                   //_sheetSlectionCounter = 2;
  //                   _genderSelected = 2;
  //
  //                   rectifySlots(_businessdetail['vendorid'].toString(),
  //                       "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
  //                       "$_sheetSlectionCounter");
  //                 });
  //
  //
  //               },
  //               groupValue: maleFemale == 1 ? 0 : 1,
  //               value: 1,
  //             ),
  //
  //           ],
  //         ) : Container(),
  //
  //       ],
  //     ),
  //   );
  // }


  String userAddress = "";

  void getUserName() {
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        _username = value.data()!;
        la = value.data()!['lat'] == null ? "0" : value.data()!['lat'];
        lo = value.data()!['log'] == null ? "0" : value.data()!['log'];

        GeoCode geoCode = new GeoCode();

        geoCode.reverseGeocoding(latitude: double.parse(la), longitude: double.parse(lo)).then((value) {

          userAddress = "${value.streetAddress}, ${value.city}";

        });
      });
    });
  }


  void getGallery() {
    imgList.clear();
    FirebaseFirestore.instance.collection("gallery")
        .doc(salonid)
        .collection("gallery")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          imgList.add(element.data()['url']);
        });
      });
    });
  }

  void getBusinessDetails() {
    FirebaseFirestore.instance.collection("business").doc(salonid).get().then((
        value) {
      setState(() {
        _businessdetail = value.data()!;

        _seatcount = int.parse(gender == "male" ? _businessdetail['hairMaleSeats'] : _businessdetail['hairFemaleSeats']);


        print("_seatcount = $_seatcount");


        //getSlots();
      });
    });
  }

  void getSalonData(String serviceid) {
    FirebaseFirestore.instance.collection("services").doc(salonid)
        .collection("service").doc(serviceid).get().then((value) {
      setState(() {
        _servicedata.add(value.data()!);

        totalduration = totalduration + int.parse(value.data()!['serviceduration']);
        totalPrice = totalPrice + double.parse(value.data()!['price']);
        print(_servicedata);
      });
    });
  }



  //declaration
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;
  double scaleFactor = 0;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
    'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg',
    'https://static.businessworld.in/article/article_extra_large_image/1589448910_mKTyMh_salon_mangalore4.jpg'
  ];

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;

        getBusinessDetails();

        rectifySlots(_businessdetail['vendorid'].toString(),
            "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",gender);

      });

    switch (DateFormat('EEEE').format(pickedDate!)) {
      case "Sunday":
        setState(() {
          index = 6;
        });
        break;

      case "Monday":
        setState(() {
          index = 0;
        });
        break;

      case "Tuesday":
        setState(() {
          index = 1;
        });
        break;

      case "Wednesday":
        setState(() {
          index = 2;
        });
        break;

      case "Thursday":
        setState(() {
          index = 3;
        });
        break;

      case "Friday":
        setState(() {
          index = 4;
        });
        break;

      case "Saturday":
        setState(() {
          index = 5;
        });
        break;
    }

    //getSlots();
  }


  @override
  void initState() {

    // String cartid = Uuid().v1().toString();
    // c = Cart(FirebaseAuth.instance.currentUser!.uid,servicetype,gender,salonid,serviceid,cartid,"pending","true");
    // c.push().then((value){
    //   print("done");
    // });

    getUserName();
    getGallery();
    getBusinessDetails();
    serviceid.forEach((element) {
      getSalonData(element);
    });



    switch (DateFormat('EEEE').format(DateTime.now())) {
      case "Sunday":
        setState(() {
          index = 6;
        });
        break;

      case "Monday":
        setState(() {
          index = 0;
        });
        break;

      case "Tuesday":
        setState(() {
          index = 1;
        });
        break;

      case "Wednesday":
        setState(() {
          index = 2;
        });
        break;

      case "Thursday":
        setState(() {
          index = 3;
        });
        break;

      case "Friday":
        setState(() {
          index = 4;
        });
        break;

      case "Saturday":
        setState(() {
          index = 5;
        });
        break;
    }
    print(index);
  }


  void getSlots() {

    slotsData.clear();
    selectSlot.clear();
    print(_businessdetail);

    if (_businessdetail != null) {
      if (_businessdetail.isNotEmpty) {
        String start = _businessdetail["businessTiming"][index]['$index']['start'];
        String end = _businessdetail["businessTiming"][index]['$index']['end'];

        DateTime startTimeIteration = DateFormat("hh : mm").parse(start);

        DateTime endTimeIteration = DateFormat("hh : mm").parse(end);


        slotsData[startTimeIteration.hour] = [];


        print("jjjj");
        print(slotsData);

//        print(endTimeIteration.hour);

        //
        while (startTimeIteration.hour < endTimeIteration.hour) {
          if (slotsData[startTimeIteration.hour] == null) {
            setState(() {
              slotsData[startTimeIteration.hour] = [];
              slotsData[startTimeIteration.hour]!.add(NewSlots(
                  "${startTimeIteration.hour} : ${startTimeIteration.minute}",
                  0));
            });
          }
          else {
            setState(() {
              slotsData[startTimeIteration.hour]!.add(NewSlots(
                  "${startTimeIteration.hour} : ${startTimeIteration.minute}",
                  0));
            });

            //      print(slotsData);
          }
          // if (startTimeIteration.hour == null) {
          //   setState(() {
          //     slotsData[startTimeIteration.hour] = [];
          //     slotsData[startTimeIteration.hour]!.add(Slots(
          //         "${startTimeIteration.hour} : ${startTimeIteration.minute}",
          //         0));
          //   });
          // }
          // else {
          //   if (slotsData["${startTimeIteration.hour}"] == null) {
          //     setState(() {
          //       slotsData[startTimeIteration.hour] = [];
          //       slotsData[startTimeIteration.hour]!.add(Slots(
          //           "${startTimeIteration.hour} : ${startTimeIteration.minute}",
          //           0));
          //     });
          //   }
          //   else {
          //     setState(() {
          //       slotsData['${startTimeIteration.hour}']!.add(Slots(
          //           "${startTimeIteration.hour} : ${startTimeIteration.minute}",
          //           0));
          //     });
          //   }
          // }

          startTimeIteration = startTimeIteration.add(Duration(seconds: 600));
        }
        //
        // slotsData.forEach((key, value) {
        //   print(key);
        // });


        print("sahil zala jnf = ${startTimeIteration.hour}");
      }
    }
  }

  void bookSlots(userid, vendorid, serviceid, seattype, selecteddate, seatnumber, gender, starttime, endtime, servicestatus, totalduration, slotcount, data)
  {
    Navigator.pop(context);


    OrderClass oc = OrderClass(userid, vendorid, serviceid, seattype, selecteddate, seatnumber, gender, starttime, endtime, servicestatus, totalduration, slotcount, data,la,lo,userAddress);
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => OrderPreview(oc)));

    oc.servicetype = "service";


    oc.paymentstatus = newoc.paymentstatus;
    oc.totalduration = newoc.totalduration;
    oc.total = newoc.total;
    oc.finaltotal = newoc.finaltotal;
    oc.disount = newoc.disount;
    oc.orderid = newoc.orderid;


    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PackageRescheduleOrderPreview(oc)));




    // oc.bookeService().then((value){
    //
    //   setState(() {
    //     progressBar = 0;
    //   });
    //
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => BookedDone()));
    //
    //   print("done");
    // }).catchError((onError){
    //
    //   setState(() {
    //     progressBar = 0;
    //   });
    //
    //   print(onError);0
    // });
  }

  void rectifySlots(String businessid,String date,String gender){
    OrderClass obj = OrderClass.check();


    print("dddd ${newoc.seattype}");
    obj.checkOrderDataNew(businessid, date, gender,newoc.seattype).then((value){

      if(value.docs.isNotEmpty) {

        getSlots();

        value.docs.forEach((element) {
          Map slots = element.data()["slots"];



          slots.keys.forEach((element) {
            DateTime time = DateFormat("HH : mm").parse(element.toString());

            List<NewSlots>? val = slotsData[time.hour];

            print("hhh  ${slotsData}");
            val!.forEach((element) {

              if(element.start == "${time.hour} : ${time.minute}")
              {
                setState(() {
                  //element.status = 2;
                  element.seatcount++;

                  if(element.seatcount == _seatcount){
                    element.status = 2;
                  }
                });
              }
            });
          });
        });
      }
      else{
        getSlots();
        print("no booking on this date");
      }
    }).catchError((onError){
      print(onError);
    });


  }
  Widget getSalonContainer() {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery
          .of(context)
          .size
          .width,

      child: Column(
        children: [
          getSliderContainer(),
          getSalonDetails()
        ],
      ),
    );
  }

  Widget getSalonDetails() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,

      child: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _businessdetail != null ? _businessdetail.isNotEmpty
                  ? "${_businessdetail['businessName']}"
                  : "Tunning Salon" : "xyz",
              textScaleFactor: 0.9,
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntum",
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10,),

            Row(
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  itemSize: 20,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) =>
                      Icon(
                        Icons.star,
                        color: getMateGold(),
                      ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),

                Text(
                  "3.0",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: getMateGold(),
                    fontSize: 20,
                    fontFamily: "ubuntub",

                  ),
                ),

                SizedBox(width: 5,),
                Container(
                  height: 15,
                  width: 2,
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  color: Colors.grey[400],
                ),

                SizedBox(width: 5,),

                Text(
                  "( 1,000 reviews )",
                  style: TextStyle(
                    color: getGrey(),
                    fontSize: 15,
                    fontFamily: "ubuntul",

                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 15,
                  color: getMateGold(),
                ),

                SizedBox(width: 5,),

                Expanded(
                  flex: 2,
                  child: Text(

                    _businessdetail != null ? _businessdetail.isNotEmpty
                        ? "${_businessdetail['address']}"
                        : "Tunning Salon" : "xyz",

                    textScaleFactor: 0.9,style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                  ),
                ),
              ],
            ),


            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.watch_later_outlined,
                            color: getBlackMate(),
                            size: 15,
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Text(
                              _businessdetail != null ? _businessdetail
                                  .isNotEmpty
                                  ? "${_businessdetail["businessTiming"][index]['$index']['start']} | ${_businessdetail["businessTiming"][index]['$index']['end']}"
                                  : "Tunning Salon" : "xyz",
                              textScaleFactor: 0.9,style: TextStyle(
                              color: getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur",
                            ),
                            ),
                          ),


                        ],
                      )
                  ),
                ),

                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _businessdetail != null ? _businessdetail.isNotEmpty
                              ? _businessdetail['homeappointment'] == 'true'
                              ? "At Home / At Salon "
                              : "At Salon"
                              : "xyz" : "xyz",
                          textScaleFactor: 0.9,style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 15,
                            fontFamily: "ubuntur"
                        ),
                        )
                      ],
                    ),

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
                  flex: 1,
                  child: Container(
                    child: SingleChildScrollView(
                      physics: new BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("Open - ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntub",
                                fontSize: 15
                            ),
                          ),

                          Text("S ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][6]['6']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),
                          Text(" M ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][0]['0']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" T ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][1]['1']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" W ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][2]['2']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" T ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][3]['3']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" F ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][4]['4']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" S ",
                            textScaleFactor: 0.9,style: TextStyle(
                                color: _businessdetail != null ? _businessdetail
                                    .isNotEmpty
                                    ? _businessdetail['businessTiming'][5]['5']['activate'] ==
                                    0 ? getBlackMate() : getMateGold()
                                    : Colors.grey : Colors.grey,
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Distance: ",
                          textScaleFactor: 0.9,style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 15
                          ),
                        ),

                        Text(" 5 KM",
                          textScaleFactor: 0.9,style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntum",
                              fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),

            SizedBox(height: 20),




            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey[300],

              ),
            ),

            // SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   "Select gender & seat",
            //   textScaleFactor: 0.9,style: TextStyle(
            //   color: getBlackMate(),
            //   fontFamily: "ubuntum",
            //   fontSize: 25,
            //   fontWeight: FontWeight.w600,
            // ),
            // ),

            // SizedBox(
            //   height: 20,
            // ),
            // _servicedata.isNotEmpty ?
            // getGenderWidget(_servicedata[0]['servicegender']) : getGenderWidget(
            //     "unisex"),

//            SizedBox(height: 20),


            // Column(
            //   children: [
            //     _businessdetail.isEmpty ? Container() : StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            //       return  Container(
            //         height: 80,
            //         width: MediaQuery.of(context).size.width,
            //         child: new ListView.builder
            //           (
            //             scrollDirection: Axis.horizontal,
            //             itemCount: gender == "male" ? int.parse(_businessdetail['hairMaleSeats']) : gender == "female" ? int.parse(_businessdetail['hairFemaleSeats']) : 0,
            //             itemBuilder: (BuildContext ctxt, int Index) {
            //
            //               return getSeatRow(Index+1);
            //             }
            //         ),
            //       );
            //     },
            //
            //     ),
            //
            //     SizedBox(height: 20),
            //
            //   ],
            // ),


            SizedBox(height: 20),

            Text(
              "Select Date & Time",
              textScaleFactor: 0.9,
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntum",
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Container(
                padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                decoration: BoxDecoration(
                  color: getLightGrey(),
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date : ${currentDate.day} - ${currentDate
                            .month} - ${currentDate.year}",
                        textScaleFactor: 0.9,style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 20,

                      ),
                      ),
                    ),

                    Container(
                      child: IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: getMateGold(),
                          size: 23,
                        ),
                      ),
                    )


                  ],
                )
            ),

            SizedBox(
              height: 20,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: getMateBlue(),
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Text(
                  "Available",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 15,

                      fontFamily: "ubuntub"
                  ),
                ),

                SizedBox(width: 20,),


                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: getMateGold(),
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Text(
                  "Selected",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 15,

                      fontFamily: "ubuntub"
                  ),
                ),

                SizedBox(width: 20,),

                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: getMateRed(),
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Text(
                  "Booked",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 15,

                      fontFamily: "ubuntub"
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Column(

              children: slotsData.keys.map((e) {
                dynamic data = slotsData[int.parse(e.toString())];
                return getSlotsContainer(e.toString(), data);
              }).toList(),
            ),

          ],
        ),
      ),
    );
  }

  Widget getSliderContainer() {
    return getSliderWidget();
  }

  Widget getSliderWidget() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: getLightGrey(),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: CarouselSlider(
            options: CarouselOptions(
                aspectRatio: 16 / 9,
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
                  setState(() {
                    _current = index;
                  });
                }
            ),
            items: imgList.map((item) => getSliderItem(item)).toList(),

          ),
        ),
        //getSliderItem(),

        const SizedBox(
          height: 10,
        ),
        Container(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: map<Widget>(imgList, (index, url) {
              return Container(
                margin: EdgeInsets.all(2),
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _current == index ? getMateGold() : const Color
                          .fromRGBO(102, 102, 102, 1)),
                  color: _current == index ? getMateGold() : Colors.white,
                ),
              );
            }),
          ),
        ),


      ],
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


  _SalonOrderReschedule(this.servicetype, this.gender, this.salonid, this.serviceid,this.newoc);

  String servicetype;
  String gender;
  String salonid;
  List<String> serviceid;


  String la = "0",
      lo = "0";
  Map _businessdetail = new Map();

  List<Map> _servicedata = [];

  int index = 0;

  int progressBar = 0;
  SplayTreeMap<int, List<NewSlots>> slotsData = new SplayTreeMap();
  SplayTreeMap<String, NewSlots> selectSlot = new SplayTreeMap();

  int _genderSelected = 0;

  var mySeatState;

  Map _username = new Map();
  int totalduration = 0;
  double totalPrice = 0;

  Cart c = Cart.non();

  OrderClass newoc;

  int _seatcount = 0;

}


