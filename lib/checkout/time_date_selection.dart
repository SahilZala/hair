// import 'dart:collection';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:geocode/geocode.dart';
// import 'package:hair/checkout/Order.dart';
// import 'package:hair/checkout/done.dart';
// import 'package:hair/checkout/orde_preview.dart';
// import 'package:intl/intl.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
//
// import '../colors.dart';
//
// class TimeDateSelection extends StatefulWidget
// {
//
//   String seattype;
//   String servicetype;
//   String servicecategory;
//   String salonid;
//   String serviceid;
//
//
//   TimeDateSelection(this.seattype, this.servicetype, this.servicecategory,
//       this.salonid, this.serviceid);
//
//   _TimeDateSelection createState ()=> _TimeDateSelection(this.seattype, this.servicetype, this.servicecategory,
//       this.salonid, this.serviceid);
// }
//
// class _TimeDateSelection extends State<TimeDateSelection> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     scaleFactor = MediaQuery
//         .of(context)
//         .textScaleFactor + 0.2;
//     return SafeArea(
//         child: Stack(
//           children: [
//             Scaffold(
//               body: SingleChildScrollView(
//                 physics: new BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     getSalonContainer(),
//                     SizedBox(
//                       height: 80,
//                     )
//                   ],
//                 ),
//               ),
//
//               appBar: AppBar(
//                 elevation: 0,
//                 backgroundColor: getBlackMate(),
//                 title: Text(
//                   "Hair Cut",
//                   textScaleFactor: 0.9,
//                   style: TextStyle(
//                     color: getMateGold(),
//                     fontFamily: "ubuntur",
//                     fontSize: 25,
//                   ),
//                 ),
//               ),
//             ),
//
//             Container(
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height,
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10))
//                     ),
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Material(
//                             child: Container(
//                               padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "${_servicedata['serviceduration']} Minute",
//                                     textScaleFactor: 0.9,
//                                     style: TextStyle(
//                                       color: getMateGold(),
//                                       fontFamily: "ubuntub",
//                                       fontSize: 22
//                                     ),
//                                   ),
//
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//
//                                   Text(
//                                     "total duration",
//                                     textScaleFactor: 0.9,
//                                     style: TextStyle(
//                                         color: getBlackMate(),
//                                         fontFamily: "ubuntur",
//                                         fontSize: 13
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(15,0,15,0),
//                           child: Material(
//                             borderRadius: BorderRadius.circular(15),
//                             child: RaisedButton(
//                               color: getBlackMate(),
//                               onPressed: () {
//                                 if(int.parse(_servicedata['serviceduration']) == (selectSlot.length*10))
//                                 {
//                                   showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) => CupertinoAlertDialog(
//                                         title: new Text("do you want to proceed"),
//                                         content: new Text("?"),
//                                         actions: <Widget>[
//                                           CupertinoDialogAction(
//                                             isDefaultAction: true,
//                                             child: Text("Yes"),
//                                             onPressed: (){
//                                               bookSlots(
//                                                 FirebaseAuth.instance.currentUser!.uid.toString(),
//                                                 _businessdetail['vendorid'].toString(),
//                                                 _servicedata['serviceid'],
//                                                 seattype,
//                                                   "${currentDate.day} - ${currentDate
//                                                       .month} - ${currentDate.year}",
//                                                  "$_sheetSlectionCounter",
//                                                   _genderSelected == 1 ? "male" : "female",
//                                                 selectSlot.firstKey().toString(),
//                                                 selectSlot.lastKey().toString(),
//                                                 "pending",
//                                                 _servicedata["serviceduration"],
//                                                 "${selectSlot.length}",
//                                                 selectSlot
//                                               );
//
//                                             // Navigator.pop(context);
//                                             },
//                                         ),
//                                         CupertinoDialogAction(
//                                          child: Text("No"),
//                                           onPressed: (){
//                                            Navigator.pop(context);
//                                           },
//                                         )
//                                       ],
//                                       )
//                                   );
//                                 }
//                               },
//
//                               child: Text(
//                                   "Pay ${_servicedata['price']} /-",
//                                 textScaleFactor: 0.9,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: "ubuntub",
//
//                                     fontSize: 15
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//
//
//
//
//
//
//                       ],
//                     ),
//                     // child: Container(
//                     //
//                     //   margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                     //
//                     //   width: MediaQuery
//                     //       .of(context)
//                     //       .size
//                     //       .width,
//                     //   decoration: BoxDecoration(
//                     //     color: getBlackMate(),
//                     //     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     //   ),
//                     //   child: MaterialButton(
//                     //     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                     //     minWidth: MediaQuery
//                     //         .of(context)
//                     //         .size
//                     //         .width,
//                     //
//                     //     onPressed: () async {
//                     //       // Navigator.push(
//                     //       //     context,
//                     //       //     MaterialPageRoute(builder: (context) => TimeDateSelection()));
//                     //     },
//                     //     child: Text(
//                     //       "CONTINUE",
//                     //       textScaleFactor: 0.9, style: TextStyle(
//                     //         color: getMateGold(),
//                     //         fontSize: 18 / scaleFactor
//                     //     ),
//                     //     ),
//                     //     color: getBlackMate(),
//                     //     elevation: 0,
//                     //   ),
//                     // ),
//                   )
//                 ],
//               ),
//             ),
//
//
//             progressBar == 0 ? Container() : Center(child: CircularProgressIndicator()),
//
//
//           ],
//         )
//     );
//   }
//
//   Widget getSalonContainer() {
//     return Container(
//       padding: EdgeInsets.all(15),
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//
//       child: Column(
//         children: [
//           getSliderContainer(),
//           getSalonDetails()
//         ],
//       ),
//     );
//   }
//
//
//   Widget getSliderContainer() {
//     return getSliderWidget();
//   }
//
//   Widget getSliderWidget() {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: getLightGrey(),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           width: MediaQuery
//               .of(context)
//               .size
//               .width,
//           child: CarouselSlider(
//             options: CarouselOptions(
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 1.0,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 reverse: false,
//                 autoPlay: true,
//                 autoPlayInterval: Duration(seconds: 3),
//                 autoPlayAnimationDuration: Duration(milliseconds: 800),
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged: (index, s) {
//                   setState(() {
//                     _current = index;
//                   });
//                 }
//             ),
//             items: imgList.map((item) => getSliderItem(item)).toList(),
//
//           ),
//         ),
//         //getSliderItem(),
//
//         const SizedBox(
//           height: 10,
//         ),
//         Container(
//
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: map<Widget>(imgList, (index, url) {
//               return Container(
//                 margin: EdgeInsets.all(2),
//                 width: 10.0,
//                 height: 10.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                       color: _current == index ? getMateGold() : const Color
//                           .fromRGBO(102, 102, 102, 1)),
//                   color: _current == index ? getMateGold() : Colors.white,
//                 ),
//               );
//             }),
//           ),
//         ),
//
//
//       ],
//     );
//   }
//
//
//   Widget getSliderItem(String url) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//       height: 180,
//       decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(
//                 url
//             ),
//             fit: BoxFit.fill,
//           ),
//           borderRadius: BorderRadius.circular(10)
//       ),
//     );
//   }
//
//   Widget getSalonDetails() {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//
//       child: SingleChildScrollView(
//         physics: new BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _businessdetail != null ? _businessdetail.isNotEmpty
//                   ? "${_businessdetail['businessName']}"
//                   : "Tunning Salon" : "xyz",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color: getBlackMate(),
//                 fontFamily: "ubuntum",
//                 fontSize: 30,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             SizedBox(height: 10,),
//
//             Row(
//               children: [
//                 RatingBar.builder(
//                   initialRating: 3,
//                   minRating: 1,
//                   itemSize: 20,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                   itemBuilder: (context, _) =>
//                       Icon(
//                         Icons.star,
//                         color: getMateGold(),
//                       ),
//                   onRatingUpdate: (rating) {
//                     print(rating);
//                   },
//                 ),
//
//                 Text(
//                   "3.0",
//                   textScaleFactor: 0.9,
//                   style: TextStyle(
//                     color: getMateGold(),
//                     fontSize: 20,
//                     fontFamily: "ubuntub",
//
//                   ),
//                 ),
//
//                 SizedBox(width: 5,),
//                 Container(
//                   height: 15,
//                   width: 2,
//                   margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                   color: Colors.grey[400],
//                 ),
//
//                 SizedBox(width: 5,),
//
//                 Text(
//                   "( 1,000 reviews )",
//                   style: TextStyle(
//                     color: getGrey(),
//                     fontSize: 15,
//                     fontFamily: "ubuntul",
//
//                   ),
//                 ),
//
//               ],
//             ),
//
//             SizedBox(height: 10,),
//
//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   size: 15,
//                   color: getMateGold(),
//                 ),
//
//                 SizedBox(width: 5,),
//
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//
//                     _businessdetail != null ? _businessdetail.isNotEmpty
//                         ? "${_businessdetail['address']}"
//                         : "Tunning Salon" : "xyz",
//
//                     textScaleFactor: 0.9,style: TextStyle(
//                         color: getMateGold(),
//                         fontFamily: "ubuntur",
//                         fontSize: 15
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//
//             SizedBox(
//               height: 10,
//             ),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                       child: Row(
//                         children: [
//                           Icon(Icons.watch_later_outlined,
//                             color: getBlackMate(),
//                             size: 15,
//                           ),
//                           SizedBox(width: 5,),
//                           Expanded(
//                             child: Text(
//                               _businessdetail != null ? _businessdetail
//                                   .isNotEmpty
//                                   ? "${_businessdetail["businessTiming"][index]['$index']['start']} | ${_businessdetail["businessTiming"][index]['$index']['end']}"
//                                   : "Tunning Salon" : "xyz",
//                               textScaleFactor: 0.9,style: TextStyle(
//                                 color: getBlackMate(),
//                                 fontSize: 15,
//                                 fontFamily: "ubuntur",
//                               ),
//                             ),
//                           ),
//
//
//                         ],
//                       )
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.centerRight,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           _businessdetail != null ? _businessdetail.isNotEmpty
//                               ? _businessdetail['homeappointment'] == 'true'
//                               ? "At Home / At Salon "
//                               : "At Salon"
//                               : "xyz" : "xyz",
//                           textScaleFactor: 0.9,style: TextStyle(
//                               color: getBlackMate(),
//                               fontSize: 15,
//                               fontFamily: "ubuntur"
//                           ),
//                         )
//                       ],
//                     ),
//
//                   ),
//                 )
//               ],
//             ),
//
//
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     child: SingleChildScrollView(
//                       physics: new BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Text("Open - ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: getBlackMate(),
//                                 fontFamily: "ubuntub",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text("S ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][6]['6']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//                           Text(" M ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][0]['0']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text(" T ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][1]['1']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text(" W ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][2]['2']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text(" T ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][3]['3']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text(" F ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][4]['4']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                           Text(" S ",
//                             textScaleFactor: 0.9,style: TextStyle(
//                                 color: _businessdetail != null ? _businessdetail
//                                     .isNotEmpty
//                                     ? _businessdetail['businessTiming'][5]['5']['activate'] ==
//                                     0 ? getBlackMate() : getMateGold()
//                                     : Colors.grey : Colors.grey,
//                                 fontFamily: "ubuntum",
//                                 fontSize: 15
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text("Distance: ",
//                           textScaleFactor: 0.9,style: TextStyle(
//                               color: getBlackMate(),
//                               fontFamily: "ubuntub",
//                               fontSize: 15
//                           ),
//                         ),
//
//                         Text(" 5 KM",
//                           textScaleFactor: 0.9,style: TextStyle(
//                               color: getBlackMate(),
//                               fontFamily: "ubuntum",
//                               fontSize: 15
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//               ],
//             ),
//
//             SizedBox(height: 20),
//
//
//
//
//             Container(
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width,
//               height: 2,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Select gender & seat",
//               textScaleFactor: 0.9,style: TextStyle(
//                 color: getBlackMate(),
//                 fontFamily: "ubuntum",
//                 fontSize: 25,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//             _servicedata.isNotEmpty ?
//             getGenderWidget(_servicedata['servicegender']) : getGenderWidget(
//                 "unisex"),
//
//             SizedBox(height: 20),
//
//
//             _genderSelected != 0 ?  Column(
//               children: [
//                 StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
//                   return  Container(
//                     height: 80,
//                     width: MediaQuery.of(context).size.width,
//                     child: new ListView.builder
//                       (
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _genderSelected == 1 ? int.parse(_businessdetail['hairMaleSeats']) : _genderSelected == 2 ? int.parse(_businessdetail['hairFemaleSeats']) : 0,
//                         itemBuilder: (BuildContext ctxt, int Index) {
//
//                           return getSeatRow(Index+1);
//                         }
//                     ),
//                   );
//                 },
//
//                 ),
//
//                 SizedBox(height: 20),
//
//               ],
//             ) : Container(),
//
//
//             SizedBox(height: 20),
//
//             Text(
//               "Select Date & Time",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color: getBlackMate(),
//                 fontFamily: "ubuntum",
//                 fontSize: 25,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             Container(
//                 padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
//                 decoration: BoxDecoration(
//                   color: getLightGrey(),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Date : ${currentDate.day} - ${currentDate
//                             .month} - ${currentDate.year}",
//                         textScaleFactor: 0.9,style: TextStyle(
//                           color: getBlackMate(),
//                           fontSize: 20,
//
//                         ),
//                       ),
//                     ),
//
//                     Container(
//                       child: IconButton(
//                         onPressed: () {
//                           _selectDate(context);
//                         },
//                         icon: Icon(
//                           Icons.calendar_today,
//                           color: getMateGold(),
//                           size: 23,
//                         ),
//                       ),
//                     )
//
//
//                   ],
//                 )
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 15,
//                   width: 15,
//                   decoration: BoxDecoration(
//                     color: getMateBlue(),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: 5,
//                 ),
//
//                 Text(
//                   "Available",
//                   textScaleFactor: 0.9,
//                   style: TextStyle(
//                       color: getBlackMate(),
//                       fontSize: 15,
//
//                       fontFamily: "ubuntub"
//                   ),
//                 ),
//
//                 SizedBox(width: 20,),
//
//
//                 Container(
//                   height: 15,
//                   width: 15,
//                   decoration: BoxDecoration(
//                     color: getMateGold(),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: 5,
//                 ),
//
//                 Text(
//                   "Selected",
//                   textScaleFactor: 0.9,
//                   style: TextStyle(
//                       color: getBlackMate(),
//                       fontSize: 15,
//
//                       fontFamily: "ubuntub"
//                   ),
//                 ),
//
//                 SizedBox(width: 20,),
//
//                 Container(
//                   height: 15,
//                   width: 15,
//                   decoration: BoxDecoration(
//                     color: getMateRed(),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: 5,
//                 ),
//
//                 Text(
//                   "Booked",
//                   textScaleFactor: 0.9,
//                   style: TextStyle(
//                       color: getBlackMate(),
//                       fontSize: 15,
//
//                       fontFamily: "ubuntub"
//                   ),
//                 )
//               ],
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             Column(
//
//               children: slotsData.keys.map((e) {
//                 dynamic data = slotsData[int.parse(e.toString())];
//                 return getSlotsContainer(e.toString(), data);
//               }).toList(),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget getSlotsContainer(String slot, List<Slots> data) {
//     return Material(
//       elevation: 2,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//         ),
//
//         child: Column(
//           children: [
//             Text(
//               "$slot : 00",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color: getBlackMate(),
//                 fontFamily: "ubuntub",
//                 fontSize: 23,
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//
//             Wrap(
//               spacing: 15,
//               runSpacing: 15,
//               crossAxisAlignment: WrapCrossAlignment.center,
//
//               children: data.map((e) {
//
//                 return getTimeSlot(e);
//               }).toList(),
//
//               // children: [
//               //
//               //   getTimeSlot("9 : 00 AM",0),
//               //   getTimeSlot("9 : 10 AM",1),
//               //   getTimeSlot("9 : 20 AM",2),
//               //   getTimeSlot("9 : 30 AM",1),
//               //   getTimeSlot("9 : 40 AM",0),
//               //   getTimeSlot("9 : 50 AM",2),
//               // ],
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget getTimeSlot(Slots e) {
//     return Container(
//
//       width: 85,
//       alignment: Alignment.center,
//
//       //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: e.status == 0 ? getMateBlue() : e.status == 1
//               ? getMateGold()
//               : getMateRed(), width: 2.0)
//       ),
//       child: RaisedButton(
//         padding: EdgeInsets.all(0),
//         elevation: 0,
//         color: Colors.white,
//         onPressed: () {
//
//           if(e.status == 0) {
//
//             if (selectSlot.isNotEmpty) {
//
//               selectSlot.forEach((key, value) {
//                 setState(() {
//                   selectSlot[key]!.status = 0;
//                 });
//                 print("giloy = ${key}");
//               });
//               selectSlot.clear();
//             }
//
//             print(selectSlot);
//
//
//             DateTime custom = DateFormat("HH : mm").parse(e.start.toString());
//
//             for (int i = 0; i < int.parse(_servicedata['serviceduration']);
//             i = i + 10) {
//               int hour = custom.hour;
//
//               print("dsdsdd = ${custom}");
//
//               List<Slots>? data = slotsData[hour];
//
//               for (int i = 0; i < data!.length; i++) {
//                 DateTime check = DateFormat("HH : mm").parse(data
//                     .elementAt(i)
//                     .start
//                     .toString());
//
//                 if (check.compareTo(custom) == 0) {
//                   if (data
//                       .elementAt(i)
//                       .status == 0) {
//                     selectSlot[data
//                         .elementAt(i)
//                         .start] = data.elementAt(i);
//                   }
//                   else {
//                     selectSlot.clear();
//                   }
//                 }
//               }
//
//               custom = custom.add(Duration(seconds: 600));
//             }
//
//
//             print(selectSlot);
//
//             selectSlot.forEach((key, value) {
//               setState(() {
//                 selectSlot[key]!.status = 1;
//               });
//             });
//           }
//           else{
//
//             if (selectSlot.isNotEmpty) {
//
//               selectSlot.forEach((key, value) {
//                 setState(() {
//                   selectSlot[key]!.status = 0;
//                 });
//                 print("giloy = ${key}");
//               });
//               selectSlot.clear();
//             }
//
//             // showTopSnackBar(
//             //     context,
//             //     CustomSnackBar.error(
//             //       message: "this is not allowed",
//             //       textStyle: TextStyle(
//             //           fontFamily: "ubuntub",
//             //           color: Colors.white,
//             //           fontSize: 15
//             //       ),
//             //     )
//             // );
//           }
//           // if(selectSlot.isEmpty) {
//           //   if (e.status == 0) {
//           //     setState(() {
//           //       // DateTime custom = DateFormat("hh : mm").parse(e.start.toString());
//           //
//           //       // if(custom.hour < 10)
//           //       // {
//           //       //   e.start = "0"+e.start;
//           //       // }
//           //
//           //       e.status = 1;
//           //       selectSlot[e.start] = e;
//           //      // print(selectSlot.keys);
//           //     });
//           //   }
//           //   else if (e.status == 1) {
//           //     setState(() {
//           //
//           //
//           //       e.status = 0;
//           //       selectSlot.remove(e.start);
//           //       print(selectSlot.keys);
//           //     });
//           //   }
//           // }
//           // else{
//           //
//           //   // DateTime lastTime = DateFormat("hh : mm").parse(selectSlot.lastKey().toString());
//           //   //
//           //   // DateTime firstTime = DateFormat("hh : mm").parse(selectSlot.firstKey().toString());
//           //   //
//           //   // int diff = (((lastTime.hour*60)+lastTime.minute) - ((firstTime.hour*60)+firstTime.minute));
//           //   //
//           //
//           //
//           //     String last = selectSlot.lastKey().toString();
//           //
//           //     DateTime lastTime = DateFormat("hh : mm").parse(last);
//           //
//           //     DateTime selectedTime = DateFormat("hh : mm").parse(e.start);
//           //
//           // //    print(selectSlot.keys);
//           //
//           //  //   print(selectedTime.minute);
//           //
//           //     if (e.status == 0) {
//           //
//           //       if(int.parse(_servicedata['serviceduration']) != (selectSlot.length*10)) {
//           //         if ((((lastTime.hour * 60) + lastTime.minute) -
//           //             ((selectedTime.hour * 60) + selectedTime.minute)) ==
//           //             -10) {
//           //           setState(() {
//           //
//           //             // DateTime custom = DateFormat("hh : mm").parse(e.start.toString());
//           //             //
//           //             // if(custom.hour < 10)
//           //             // {
//           //             //   e.start = "0"+e.start;
//           //             //
//           //             //   print("hhhhhh");
//           //             //   print(e.start);
//           //             // }
//           //
//           //
//           //             e.status = 1;
//           //             selectSlot[e.start] = e;
//           //            // print(selectSlot.keys);
//           //           });
//           //         }
//           //         else {
//           //           showTopSnackBar(
//           //               context,
//           //               CustomSnackBar.error(
//           //                 message: "this is not allowed",
//           //                 textStyle: TextStyle(
//           //                     fontFamily: "ubuntub",
//           //                     color: Colors.white,
//           //                     fontSize: 15
//           //                 ),
//           //               )
//           //           );
//           //         }
//           //       }
//           //       else{
//           //         showTopSnackBar(
//           //             context,
//           //             CustomSnackBar.error(
//           //               message: "you reached max duration",
//           //               textStyle: TextStyle(
//           //                   fontFamily: "ubuntub",
//           //                   color: Colors.white,
//           //                   fontSize: 15
//           //               ),
//           //             )
//           //         );
//           //       }
//           //   }
//           //   else if (e.status == 1) {
//           //     if ((((lastTime.hour * 60) + lastTime.minute) -
//           //         ((selectedTime.hour * 60) + selectedTime.minute)) == 0) {
//           //       setState(() {
//           //         e.status = 0;
//           //         selectSlot.remove(e.start);
//           //         print(selectSlot.keys);
//           //       });
//           //     }
//           //     else {
//           //       showTopSnackBar(
//           //           context,
//           //           CustomSnackBar.error(
//           //             message: "this is not allowed",
//           //             textStyle: TextStyle(
//           //                 fontFamily: "ubuntub",
//           //                 color: Colors.white,
//           //                 fontSize: 15
//           //             ),
//           //           )
//           //       );
//           //     }
//           //   }
//           //
//           // }
//         },
//         child: Text(
//           e.start,
//           textScaleFactor: 0.9,
//           style: TextStyle(
//               color: getBlackMate(),
//               fontFamily: "ubuntur",
//               fontSize: 15
//           ),
//         ),
//       ),
//     );
//   }
//
//   int maleFemale = 0;
//
//   Widget getGenderWidget(String servicegender) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//       margin: EdgeInsets.all(0),
//       padding: EdgeInsets.all(0),
//
//       child: Row(
//         children: [
//
//
//           servicegender == "male" || servicegender == "unisex" ? Row(
//             children: [
//
//               Text(
//                 "male",
//                 textScaleFactor: 0.9,style: TextStyle(
//                     color: getBlackMate(),
//                     fontSize: 22,
//                     fontFamily: "ubuntur"
//                 ),
//               ),
//
//               Radio(
//
//                 splashRadius: 60,
//                 focusColor: getBlackMate(),
//                 activeColor: getMateGold(),
//                 onChanged: (value) {
//                   setState(() {
//                     maleFemale = 1;
//                    // _sheetSlectionCounter = 1;
//                     _genderSelected = 1;
//
//                     rectifySlots(_businessdetail['vendorid'].toString(),
//                         "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
//                         "$_sheetSlectionCounter");
//                   });
//
//
//
//                 },
//                 groupValue: maleFemale,
//                 value: 1,
//               ),
//
//
//             ],
//           ) : Container(),
//
//
//           servicegender == "female" || servicegender == "unisex" ? Row(
//             children: [
//
//               Text(
//                 "female",
//                 textScaleFactor: 0.9,style: TextStyle(
//                     color: getBlackMate(),
//                     fontSize: 22,
//                     fontFamily: "ubuntur"
//                 ),
//               ),
//
//               Radio(
//
//                 splashRadius: 60,
//                 focusColor: getBlackMate(),
//                 activeColor: getMateGold(),
//                 onChanged: (value) {
//                   setState(() {
//                     maleFemale = 0;
//                     //_sheetSlectionCounter = 2;
//                     _genderSelected = 2;
//
//                     rectifySlots(_businessdetail['vendorid'].toString(),
//                         "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
//                         "$_sheetSlectionCounter");
//                   });
//
//
//                   },
//                 groupValue: maleFemale == 1 ? 0 : 1,
//                 value: 1,
//               ),
//
//             ],
//           ) : Container(),
//
//         ],
//       ),
//     );
//   }
//
//
//   String userAddress = "";
//
//   void getUserName() {
//     FirebaseFirestore.instance.collection("users")
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .get()
//         .then((value) {
//       setState(() {
//         _username = value.data()!;
//         la = value.data()!['lat'] == null ? "0" : value.data()!['lat'];
//         lo = value.data()!['log'] == null ? "0" : value.data()!['log'];
//
//         GeoCode geoCode = new GeoCode();
//
//         geoCode.reverseGeocoding(latitude: double.parse(la), longitude: double.parse(lo)).then((value) {
//
//           userAddress = "${value.streetAddress}, ${value.city}";
//
//         });
//       });
//     });
//   }
//
//
//   void getGallery() {
//     imgList.clear();
//     FirebaseFirestore.instance.collection("gallery")
//         .doc(salonid)
//         .collection("gallery")
//         .get()
//         .then((value) {
//       value.docs.forEach((element) {
//         setState(() {
//           imgList.add(element.data()['url']);
//         });
//       });
//     });
//   }
//
//   void getBusinessDetails() {
//     FirebaseFirestore.instance.collection("business").doc(salonid).get().then((
//         value) {
//       setState(() {
//         _businessdetail = value.data()!;
//
//         //getSlots();
//       });
//     });
//   }
//
//   void getSalonData(String serviceid) {
//     FirebaseFirestore.instance.collection("services").doc(salonid)
//         .collection("service").doc(serviceid).get().then((value) {
//       setState(() {
//         _servicedata = value.data()!;
//         print(_servicedata);
//       });
//     });
//   }
//
//
//   Widget getSeatRow(int count) {
//
//     return StatefulBuilder(
//       builder: (BuildContext context, void Function(void Function()) setState1) {
//         return GestureDetector(
//           onTap: () {
//
//             setState(() {
//               if(_sheetSlectionCounter == count) {
//                 _sheetSlectionCounter = -1;
//               }
//               else{
//                 _sheetSlectionCounter = count;
//                // currentDate
//                 rectifySlots(_businessdetail['vendorid'].toString(),
//                   "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
//                 "$_sheetSlectionCounter");
//               }
//
//
//
//               print(_sheetSlectionCounter);
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
//             child: Material(
//               borderRadius: BorderRadius.circular(5),
//               elevation: _sheetSlectionCounter == count ? 10 : 0,
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery
//                       .of(context)
//                       .size
//                       .width / 3 - 50,
//                 ),
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: _sheetSlectionCounter == count ? getMateGold() :Colors.transparent,
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 25,
//                       width: 25,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(
//                                 "images/chair.png",
//                               ),
//                               fit: BoxFit.cover
//                           )
//                       ),
//                     ),
//
//                     SizedBox(height: 8,),
//
//                     Text(
//                       "$count",
//                       textAlign: TextAlign.center,
//                       textScaleFactor: 0.9,
//                       style: TextStyle(
//                           color: getBlackMate(),
//                           fontSize: 14,
//                           fontFamily: "ubuntur"
//                       ),
//                     )
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   //declaration
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }
//
//   int _current = 0;
//   double scaleFactor = 0;
//   final List<String> imgList = [
//     'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
//     'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg',
//     'https://static.businessworld.in/article/article_extra_large_image/1589448910_mKTyMh_salon_mangalore4.jpg'
//   ];
//
//   DateTime currentDate = DateTime.now();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: currentDate,
//         firstDate: DateTime.now(),
//         lastDate: DateTime(2050));
//     if (pickedDate != null && pickedDate != currentDate)
//       setState(() {
//         currentDate = pickedDate;
//
//         rectifySlots(_businessdetail['vendorid'].toString(),
//             "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
//             "$_sheetSlectionCounter");
//       });
//
//     switch (DateFormat('EEEE').format(pickedDate!)) {
//       case "Sunday":
//         setState(() {
//           index = 6;
//         });
//         break;
//
//       case "Monday":
//         setState(() {
//           index = 0;
//         });
//         break;
//
//       case "Tuesday":
//         setState(() {
//           index = 1;
//         });
//         break;
//
//       case "Wednesday":
//         setState(() {
//           index = 2;
//         });
//         break;
//
//       case "Thursday":
//         setState(() {
//           index = 3;
//         });
//         break;
//
//       case "Friday":
//         setState(() {
//           index = 4;
//         });
//         break;
//
//       case "Saturday":
//         setState(() {
//           index = 5;
//         });
//         break;
//     }
//
//     //getSlots();
//   }
//
//   String seattype;
//   String servicetype;
//   String servicecategory;
//   String salonid;
//   String serviceid;
//
//   String la = "0",
//       lo = "0";
//   Map _username = new Map();
//   Map _businessdetail = new Map();
//   int _dayindex = 0;
//   Map _servicedata = new Map();
//
//   int index = 0;
//
//
//   _TimeDateSelection(this.seattype, this.servicetype, this.servicecategory,
//       this.salonid, this.serviceid);
//
//   @override
//   void initState() {
//     getUserName();
//     getGallery();
//     getBusinessDetails();
//     getSalonData(serviceid);
//
//
//     switch (DateFormat('EEEE').format(DateTime.now())) {
//       case "Sunday":
//         setState(() {
//           index = 6;
//         });
//         break;
//
//       case "Monday":
//         setState(() {
//           index = 0;
//         });
//         break;
//
//       case "Tuesday":
//         setState(() {
//           index = 1;
//         });
//         break;
//
//       case "Wednesday":
//         setState(() {
//           index = 2;
//         });
//         break;
//
//       case "Thursday":
//         setState(() {
//           index = 3;
//         });
//         break;
//
//       case "Friday":
//         setState(() {
//           index = 4;
//         });
//         break;
//
//       case "Saturday":
//         setState(() {
//           index = 5;
//         });
//         break;
//     }
//     print(index);
//   }
//
//
//   void getSlots() {
//
//     slotsData.clear();
//     selectSlot.clear();
//     print(_businessdetail);
//
//     if (_businessdetail != null) {
//       if (_businessdetail.isNotEmpty) {
//         String start = _businessdetail["businessTiming"][index]['$index']['start'];
//         String end = _businessdetail["businessTiming"][index]['$index']['end'];
//
//         DateTime startTimeIteration = DateFormat("hh : mm").parse(start);
//
//         DateTime endTimeIteration = DateFormat("hh : mm").parse(end);
//
//
//         slotsData[startTimeIteration.hour] = [];
//
//
//         print("jjjj");
//         print(slotsData);
//
// //        print(endTimeIteration.hour);
//
//         //
//         while (startTimeIteration.hour < endTimeIteration.hour) {
//           if (slotsData[startTimeIteration.hour] == null) {
//             setState(() {
//               slotsData[startTimeIteration.hour] = [];
//               slotsData[startTimeIteration.hour]!.add(Slots(
//                   "${startTimeIteration.hour} : ${startTimeIteration.minute}",
//                   0));
//             });
//           }
//           else {
//             setState(() {
//               slotsData[startTimeIteration.hour]!.add(Slots(
//                   "${startTimeIteration.hour} : ${startTimeIteration.minute}",
//                   0));
//             });
//
//       //      print(slotsData);
//           }
//           // if (startTimeIteration.hour == null) {
//           //   setState(() {
//           //     slotsData[startTimeIteration.hour] = [];
//           //     slotsData[startTimeIteration.hour]!.add(Slots(
//           //         "${startTimeIteration.hour} : ${startTimeIteration.minute}",
//           //         0));
//           //   });
//           // }
//           // else {
//           //   if (slotsData["${startTimeIteration.hour}"] == null) {
//           //     setState(() {
//           //       slotsData[startTimeIteration.hour] = [];
//           //       slotsData[startTimeIteration.hour]!.add(Slots(
//           //           "${startTimeIteration.hour} : ${startTimeIteration.minute}",
//           //           0));
//           //     });
//           //   }
//           //   else {
//           //     setState(() {
//           //       slotsData['${startTimeIteration.hour}']!.add(Slots(
//           //           "${startTimeIteration.hour} : ${startTimeIteration.minute}",
//           //           0));
//           //     });
//           //   }
//           // }
//
//           startTimeIteration = startTimeIteration.add(Duration(seconds: 600));
//         }
//         //
//         // slotsData.forEach((key, value) {
//         //   print(key);
//         // });
//
//
//         print("sahil zala jnf = ${startTimeIteration.hour}");
//       }
//     }
//   }
//
//   void bookSlots(userid, vendorid, serviceid, seattype, selecteddate, seatnumber, gender, starttime, endtime, servicestatus, totalduration, slotcount, data)
//   {
//     Navigator.pop(context);
//     // setState(() {
//     //   progressBar = 1;
//     // });
//     List<String> servicedata = [];
//     servicedata.add(serviceid);
//     OrderClass oc = OrderClass(userid, vendorid, servicedata, seattype, selecteddate, seatnumber, gender, starttime, endtime, servicestatus, totalduration, slotcount, data,la,lo,userAddress);
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => OrderPreview(oc)));
//
//
//
//     // oc.bookeService().then((value){
//     //
//     //   setState(() {
//     //     progressBar = 0;
//     //   });
//     //
//     //   Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(builder: (context) => BookedDone()));
//     //
//     //   print("done");
//     // }).catchError((onError){
//     //
//     //   setState(() {
//     //     progressBar = 0;
//     //   });
//     //
//     //   print(onError);
//     // });
//   }
//
//   void rectifySlots(String businessid,String date,String gender,String seatnumber){
//     OrderClass obj = OrderClass.check();
//
//     obj.checkOrderData(businessid, date, gender, seatnumber,seattype).then((value){
//
//       if(value.docs.isNotEmpty) {
//
//         getSlots();
//
//         value.docs.forEach((element) {
//           Map slots = element.data()["slots"];
//
//
//           slots.keys.forEach((element) {
//             DateTime time = DateFormat("HH : mm").parse(element.toString());
//
//             List<Slots>? val = slotsData[time.hour];
//
//             print("hhh  ${slotsData}");
//             val!.forEach((element) {
//
//               if(element.start == "${time.hour} : ${time.minute}")
//               {
//                 setState(() {
//                   element.status = 2;
//                 });
//               }
//             });
//           });
//         });
//       }
//       else{
//         getSlots();
//         print("no booking on this date");
//       }
//     }).catchError((onError){
//       print(onError);
//     });
//
//
//   }
//
//
//   int progressBar = 0;
//   SplayTreeMap<int, List<Slots>> slotsData = new SplayTreeMap();
//   SplayTreeMap<String, Slots> selectSlot = new SplayTreeMap();
//
//   int _sheetSlectionCounter = 0;
//   int _genderSelected = 0;
//
//   var mySeatState;
//
// }
//
//
//
//
// //
// // class Slots
// // {
// //   String start;
// //   int status;
// //
// //   Slots(this.start, this.status);
// // }