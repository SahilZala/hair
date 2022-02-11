
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/get_near_by_salon.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/service_selection.dart';
import 'package:shimmer/shimmer.dart';

class GroomBridalListing extends StatefulWidget
{
  String gorb;
  String seattype;


  GroomBridalListing(this.gorb, this.seattype);

  _GroomBridalListing createState ()=> _GroomBridalListing(this.gorb, this.seattype);
}

class _GroomBridalListing extends State<GroomBridalListing> {

  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewUserHome()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: getBlackMate(),
          key: _scaffoldState,
          body: Container(

            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              physics: new BouncingScrollPhysics(),
              child: Column(
                children: [
                  getRectifier()
                ],
              ),
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,

              ), onPressed: () {
                _onWillPop();
                },
            ),
            elevation: 0,
            backgroundColor: getBlackMate(),
            title: Text(
              "category",
              style: TextStyle(
                color: getMateGold(),
                fontFamily: "ubuntur",
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget getRectifier() {
    return StreamBuilder(stream: getNearBySalon(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map?>> snapshot) {
          if (snapshot.hasData) {
            var mainData = snapshot.data?.docs.toList();

            if (mainData?.length != 0) {
              List<Map> actualData = [];

              mainData?.forEach((element) {
                var pp = element.data();

                print(pp!['lat']);

                if (pp['lat'] != 'lat' || pp['log'] != 'log') {
                  double lat = double.parse(pp['lat']);
                  double log = double.parse(pp['log']);

                  double llat = double.parse(la);
                  double llog = double.parse(lo);


                  double distance = Geolocator.distanceBetween(
                      lat, log, llat, llog);

                  pp['distance'] = distance;

                  actualData.add(pp);
                }
              });

              actualData.sort((a, b) =>
              (a['distance'] >= b['distance']
                  ? 1
                  : -1));

              return SingleChildScrollView(
                physics: new BouncingScrollPhysics(),
                child: Column(
                  children: actualData.map((e) {
                    return getServiceListContainer(e);
                    //return getServicWidget(e);
                  }).toList(),
                ),
              );
            }
            else {
              return Shimmer.fromColors(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: getLightGrey1(),
                  ),
                ),
                baseColor: getLightGrey1(),
                highlightColor: Colors.white,);
            }
            // return SingleChildScrollView(
            //     physics: new BouncingScrollPhysics(),
            //   child: Column(
            //     children: snapshot.data!.docs.map((e){
            //
            //
            //
            //
            //       if((la != null && lo != null) && (la != "lat" && lo != "log") &&
            //           (e.data()!['lat'] != null && e.data()!['lat'] != null) && (e.data()!['lat'] != "lat" && e.data()!['lat'] != "log"))
            //         {
            //           double lat = double.parse(e.data()!['lat']);
            //           double log = double.parse(e.data()!['log']);
            //
            //           double llat = double.parse(la);
            //           double llog = double.parse(lo);
            //
            //
            //           double distance = Geolocator.distanceBetween(
            //               lat, log, llat, llog);
            //
            //
            //           if (distance < 5000) {
            //             return getServiceListContainer(e);
            //           }
            //           else {
            //             return Container();
            //           }
            //         }
            //       else {
            //         return Container();
            //       }
            //
            //      // return
            //
            //     }).toList(),
            //   )
            // );
          }
          else {
            return Container(
                child: Text("No data found",
                  style: TextStyle(color: getBlackMate(), fontSize: 20),)
            );
          }
        });
  }

  Widget getServiceListContainer(salondata) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("services").doc(
              salondata['vendorid']).collection("service").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size != 0) {
                return SingleChildScrollView(
                    physics: new BouncingScrollPhysics(),
                    child: Column(
                      children: snapshot.data!.docs.map((e) {
                        dataFoundIndicator = 1;

                        return e != null && e.data()['seattype'] == seattype
                            && e.data()['servicetype'] == gorb
                            && e.data()['activation'] == "true"
                           // && e.data()['servicecategory'] == category
                            ? getServiceContainer(salondata, e, (seattype,
                            servicetype, servicecategory, businessid,
                            serviceid) {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context) =>
                                  ServiceSelection(
                                      seattype, servicetype, servicecategory,
                                      businessid, serviceid,"gob")));
                        }, salondata)
                            : Container();
                      }).toList(),
                    )
                );
              }
              else {
                print(dataFoundIndicator);
                if (dataFoundIndicator == 0) {
                  return Container(
                      child: Text("No data found",
                        style: TextStyle(color: getBlackMate(), fontSize: 20),)
                  );
                } else {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(250, 250, 250, 1),
                    ),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 125,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                        ), baseColor: getLightGrey1(),
                          highlightColor: Colors.white,),

                        SizedBox(
                          height: 10,
                        ),


                        Shimmer.fromColors(child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 3,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ), baseColor: getLightGrey1(),
                          highlightColor: Colors.white,),

                        SizedBox(
                          height: 10,
                        ),


                        Shimmer.fromColors(child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ), baseColor: getLightGrey1(),
                          highlightColor: Colors.white,),


                      ],
                    ),
                  );
                }
              }
            }
            else {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(250, 250, 250, 1),
                ),


                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ), baseColor: getLightGrey1(),
                      highlightColor: Colors.white,),

                    SizedBox(
                      height: 10,
                    ),


                    Shimmer.fromColors(child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ), baseColor: getLightGrey1(),
                      highlightColor: Colors.white,),

                    SizedBox(
                      height: 10,
                    ),


                    Shimmer.fromColors(child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ), baseColor: getLightGrey1(),
                      highlightColor: Colors.white,),


                  ],
                ),


              );
            }
          },
        )
    );
    // return Container(
    //   padding: EdgeInsets.all(15),
    //   child: Column(
    //     children: [
    //
    //
    //       getServiceContainer((){
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => ServiceSelection()));
    //     }),
    //
    //     ],
    //   ),
    // );
  }


  Widget getServiceContainer(salondata, servicedata, call, data) {
    // print();
    return GestureDetector(
      onTap: () {
        call(servicedata['seattype'], servicedata['servicetype'], servicedata['servicecategory'], salondata['vendorid'],
            servicedata['serviceid']);
      },
      child: Container(

        width: MediaQuery
            .of(context)
            .size
            .width,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getLightGrey1(),
        ),
        child: Column(
          children: [

            StreamBuilder(
              stream: getSalonGallaryImage(salondata['vendorid']),
              builder: (BuildContext context, AsyncSnapshot<
                  QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.docs
                      .toList()
                      .isNotEmpty == true) {
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
                            autoPlayAnimationDuration: Duration(
                                milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, s) {
                              // setState(() {
                              //   _current = index;
                              // });
                            }
                        ),
                        items: imgList!.map((item) =>
                            getSliderItem(item['url'])).toList(),

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
                  else {
                    return Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
            ),

            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 125,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Colors.grey,
            //       image: DecorationImage(
            //           image: NetworkImage(
            //             "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
            //           ),
            //           fit: BoxFit.cover
            //       )
            //   ),
            // ),

            SizedBox(
              height: 10,
            ),

            Row(
              children: [

                Expanded(
                  flex: 5,
                  child: Text(
                    "${servicedata['servicename']}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntum",
                        fontSize: 20
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: getMateGold(),
                      ),
                      Text(
                        "4.3",
                        textAlign: TextAlign.end,
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getMateGold(),
                            fontFamily: "ubuntur",
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),


            SizedBox(
              height: 5,
            ),

            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      "${salondata['address']}",
                      textScaleFactor: 0.9,

                      style: TextStyle(
                          color: getMateGold(),
                          fontFamily: "ubuntur",
                          fontSize: 15
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          servicedata['servicegender'] != 'female' ? Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: getBlackMate(),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(
                              Icons.male,
                              size: 15,
                              color: Colors.white,
                            ),
                          ) : Container(),
                          SizedBox(width: 5,),
                          servicedata['servicegender'] != 'male' ? Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: getBlackMate(),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(
                              Icons.female,
                              size: 15,
                              color: Colors.white,
                            ),
                          ) : Container()
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(
              height: 5,
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
                            style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntub",
                                fontSize: 15
                            ),
                          ),

                          Text("S ",
                            style: TextStyle(
                                color: salondata['businessTiming'][6]['6']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),
                          Text(" M ",
                            style: TextStyle(
                                color: salondata['businessTiming'][0]['0']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" T ",
                            style: TextStyle(
                                color: salondata['businessTiming'][1]['1']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" W ",
                            style: TextStyle(
                                color: salondata['businessTiming'][2]['2']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" T ",
                            style: TextStyle(
                                color: salondata['businessTiming'][3]['3']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" F ",
                            style: TextStyle(
                                color: salondata['businessTiming'][4]['4']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
                                fontFamily: "ubuntum",
                                fontSize: 15
                            ),
                          ),

                          Text(" S ",
                            style: TextStyle(
                                color: salondata['businessTiming'][5]['5']['activate'] ==
                                    0 ? getBlackMate() : getMateGold(),
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
                          style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 15
                          ),
                        ),

                        Text('${(data['distance'] / 1000).toInt()} km',
                          style: TextStyle(
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

            SizedBox(
              height: 5,
            ),

            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: SingleChildScrollView(
                physics: new BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    salondata['businessFacilitys'][0]['0'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/ac.png")
                    ) : Container(),

                    salondata['businessFacilitys'][1]['1'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/parking.png")
                    ) : Container(),

                    salondata['businessFacilitys'][2]['2'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/wifi.png")
                    ) : Container(),

                    salondata['businessFacilitys'][3]['3'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/music.png")
                    ) : Container(),

                    salondata['businessFacilitys'][8]['8'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/sanitizer.png")
                    ) : Container(),

                    salondata['businessFacilitys'][9]['9'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/sterilizer.png")
                    ) : Container(),


                    salondata['businessFacilitys'][4]['4'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/online_pay.png")
                    ) : Container(),

                    salondata['businessFacilitys'][5]['5'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/appointement.png")
                    ) : Container(),

                    salondata['businessFacilitys'][6]['6'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/temprature.png")
                    ) : Container(),

                    salondata['businessFacilitys'][7]['7'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/face_mask.png")
                    ) : Container(),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  void getUserName() {
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        username = value.data()!;
        la = value.data()!['lat'] == null ? "0" : value.data()!['lat'];
        lo = value.data()!['log'] == null ? "0" : value.data()!['log'];

        print(la);
        print(lo);
      });
    });
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


  @override
  void initState() {
    getUserName();
  }


  //declaration part


  String gorb;
  String seattype;


  _GroomBridalListing(this.gorb, this.seattype);

  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey();
  String la = "0",
      lo = "0";
  Map username = new Map();

  int dataFoundIndicator = 0;
}
