import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hair/checkout/group_service_check_out.dart';
import 'package:hair/checkout/package_service_checkout.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/home/at_home_booking.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/selected_service_preview.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class SalonDetails extends StatefulWidget
{
  String businessid;
  
  SalonDetails(this.businessid);

  _SalonDetails createState ()=> _SalonDetails(businessid);

}
class _SalonDetails extends State<SalonDetails> with SingleTickerProviderStateMixin
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
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: getBlackMate(),
                body: Container(

                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  ),

                  child: SingleChildScrollView(
                    physics: new BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        getSalonContainer()
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: getBlackMate(),
                  title: Text(
                    "${salonData['businessName']}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 25,
                    ),
                  ),

                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: getMateGold(),
                    ),


                    onPressed: () {
                      _onWillPop();
                      //print("hikjnjhhh  ${_serviceDataMap['shaving']?.length}");
                      },
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Container(

                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: getBlackMate(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery.of(context).size.width,

                          onPressed: () async {
                            List<String> serviceList = [];
                            _serviceDataMap.forEach((key, value) {
                              print("0 ${value}");

                              value.forEach((element) {
                                if(element['isSelected'] == true)
                                {
                                  serviceList.add(element['serviceid']);
                                }
                              });
                            });

                            if(serviceList.isNotEmpty)
                            {

                              if(serviceselected == 0) {
                                print(serviceList);

                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(builder: (context) =>
                                //         SalonCheckOut(salonType == 1
                                //             ? "salon"
                                //             : "treatment",
                                //             maleFemale == 1 ? "male" : "female",
                                //             businessid,
                                //             serviceList,"cp")));

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SelectedServicePreview(salonType == 1
                                            ? "salon"
                                            : "treatment",
                                            maleFemale == 1 ? "male" : "female",
                                            businessid,
                                            serviceList,"cp")));


                              }
                              else{
                                print("home");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        AtHomeBooking(salonType == 1
                                            ? "salon"
                                            : "treatment",
                                            maleFemale == 1 ? "male" : "female",
                                            businessid,
                                            serviceList,"sd")));

                              }
                            }
                            else{
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message: "please select service first ",
                                    textStyle: TextStyle(
                                        fontFamily: "ubuntub",
                                        color: Colors.white,
                                        fontSize: 15
                                    ),
                                  )
                              );
                            }
                          },
                          child: Text(
                            "CONTINUE",
                            textScaleFactor: 0.9, style: TextStyle(
                              color: getMateGold(),
                              fontSize: 18/getScaleFactor(context),
                          ),
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        ),
                      ) ,
                    )
                  ],
                ),
              ),

            ],
          )
      ),
    );
  }

  Widget getSalonContainer()
  {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: [
          getSliderContainer(),
          getSalonDetails(),

          SizedBox(height: 100),

        ],
      ),
    );
  }

  Widget getSliderContainer()
  {
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

  Widget getSalonDetails()
  {
    return salonData.length == 0 ? Container() : Container(
      width: MediaQuery.of(context).size.width,

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${salonData['businessName']}",
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

                SizedBox(width: 5,),
                Container(
                  height: 15,
                  width: 2,
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  color: Colors.grey[400],
                ),

                SizedBox(width: 5,),

                Text(
                  "( 0 reviews )",
                  style: TextStyle(
                    color: getGrey(),
                    fontSize: 15,
                    fontFamily: "ubuntul",

                  ),
                ),

              ],
            ),

            SizedBox(height:10,),

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
                    "${salonData['address']}",
                    textScaleFactor: 0.9,

                    style: TextStyle(
                        color : getMateGold(),
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
                              "${salonData["businessTiming"][index]['$index']['start']} | ${salonData["businessTiming"][index]['$index']['end']}",
                              style: TextStyle(
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
                        salonData['homeappointment'] == 'true' ? "At Home / At Salon " : "At Salon",
                          style: TextStyle(
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
              height: 20,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey[300],

              ),
            ),

            SizedBox(
              height: 20,
            ),

            Text(
              "Salon type",
              textScaleFactor: 0.9,
              style: TextStyle(
                color:  getBlackMate(),
                fontFamily: "ubuntub",
                fontSize: 20,
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Text(
              "${salonData['salonTypeInGender']}",
              textScaleFactor: 0.9,
              style: TextStyle(
                color:  getGrey(),
                fontFamily: "ubuntul",
                fontSize: 18,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Text(
              "Facilities",
              textScaleFactor: 0.9,
              style: TextStyle(
                color:  getBlackMate(),
                fontFamily: "ubuntub",
                fontSize: 20,
              ),
            ),

            SizedBox(
              height: 5,
            ),


            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    salonData.isNotEmpty ? salonData['businessFacilitys'][0]['0'] == '1' ? Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset("images/ac.png")
                    ) : Container() : Container(),

                    salonData['businessFacilitys'][1]['1'] == '1' ? Container(
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

                    salonData['businessFacilitys'][2]['2'] == '1' ? Container(
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

                    salonData['businessFacilitys'][3]['3'] == '1' ? Container(
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

                    salonData['businessFacilitys'][8]['8'] == '1' ? Container(
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

                    salonData['businessFacilitys'][9]['9'] == '1' ? Container(
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


                    salonData['businessFacilitys'][4]['4'] == '1' ? Container(
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

                    salonData['businessFacilitys'][5]['5'] == '1' ? Container(
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

                    salonData['businessFacilitys'][6]['6'] == '1' ? Container(
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

                    salonData['businessFacilitys'][7]['7'] == '1' ? Container(
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
            ),

            SizedBox(
              height: 10,
            ),

            getTimeSection(),

            SizedBox(
              height: 20,
            ),


            Text(
              "Select gender",
              textScaleFactor: 0.9,
              style: TextStyle(
                color:  getBlackMate(),
                fontFamily: "ubuntub",
                fontSize: 20,
              ),
            ),

            SizedBox(
              height: 20,
            ),


            Row(
              children: [
                _genderSelected == 1 || _genderSelected == 3 ? Text(
                  "male",
                  textScaleFactor: 0.9,style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 22,
                    fontFamily: "ubuntur"
                ),
                ) : Container(),

                _genderSelected == 1 || _genderSelected == 3 ? Radio(

                  splashRadius: 60,
                  focusColor: getBlackMate(),
                  activeColor: getMateGold(),
                  onChanged: (value) {
                    setState(() {
                       maleFemale = 1;

                       getServiceData(businessid);
                      // // _sheetSlectionCounter = 1;
                      // _genderSelected = 1;
                      //
                      // rectifySlots(_businessdetail['vendorid'].toString(),
                      //     "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
                      //     "$_sheetSlectionCounter");
                    });



                  },
                  groupValue: maleFemale,
                  value: 1,
                ) : Container(),



                _genderSelected == 2 || _genderSelected == 3 ? Text(
                  "female",
                  textScaleFactor: 0.9,style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 22,
                    fontFamily: "ubuntur"
                ),
                ) : Container(),

                _genderSelected == 2 || _genderSelected == 3 ? Radio(

                  splashRadius: 60,
                  focusColor: getBlackMate(),
                  activeColor: getMateGold(),
                  onChanged: (value) {
                    setState(() {

                      maleFemale = 0;
                      getServiceData(businessid);
                      // // _sheetSlectionCounter = 1;
                     // _genderSelected = 1;
                      //
                      // rectifySlots(_businessdetail['vendorid'].toString(),
                      //     "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
                      //     "$_sheetSlectionCounter");
                    });



                  },
                  groupValue: maleFemale == 1 ? 0 : 1,
                  value: 1,
                ) : Container(),
              ],
            ),


            SizedBox(
              height: 20,
            ),


            // Text(
            //   "Select salon type",
            //   textScaleFactor: 0.9,
            //   style: TextStyle(
            //     color:  getBlackMate(),
            //     fontFamily: "ubuntub",
            //     fontSize: 20,
            //   ),
            // ),

            // SizedBox(
            //   height: 20,
            // ),

            // Row(
            //   children: [
            //     Row(
            //       children: [
            //         Text(
            //           "salon",
            //           textScaleFactor: 0.9,style: TextStyle(
            //             color: getBlackMate(),
            //             fontSize: 22,
            //             fontFamily: "ubuntur"
            //         ),
            //         ) ,
            //
            //         Radio(
            //
            //           splashRadius: 60,
            //           focusColor: getBlackMate(),
            //           activeColor: getMateGold(),
            //           onChanged: (value) {
            //             setState(() {
            //               salonType = 1;
            //
            //               getServiceData(businessid);
            //               // // _sheetSlectionCounter = 1;
            //               // _genderSelected = 1;
            //               //
            //               // rectifySlots(_businessdetail['vendorid'].toString(),
            //               //     "${currentDate.day} - ${currentDate.month} - ${currentDate.year}",_genderSelected == 1 ? "male" : "female",
            //               //     "$_sheetSlectionCounter");
            //             });
            //
            //
            //
            //           },
            //           groupValue: salonType,
            //           value: 1,
            //         ),
            //
            //
            //
            //         Text(
            //           "treatment",
            //           textScaleFactor: 0.9,style: TextStyle(
            //             color: getBlackMate(),
            //             fontSize: 22,
            //             fontFamily: "ubuntur"
            //         ),
            //         ),
            //
            //         Radio(
            //
            //           splashRadius: 60,
            //           focusColor: getBlackMate(),
            //           activeColor: getMateGold(),
            //           onChanged: (value) {
            //             setState(() {
            //
            //               salonType = 0;
            //
            //               getServiceData(businessid);
            //             });
            //
            //           },
            //           groupValue: salonType == 1 ? 0 : 1,
            //           value: 1,
            //         ),
            //       ],
            //     ),
            //
            //   ],
            // ),

            // SizedBox(
            //   height: 20,
            // ),


            servicelocation == 1 ?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Select location",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color:  getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 20,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                 Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        padding: EdgeInsets.all(5),
                        child: Text("at salon",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur"),),
                        elevation: 0,
                        color: serviceselected == 1 ? getLightGrey() : getMateGold(),
                        onPressed: () {

                          print("dsdssddsdsdsdsds $serviceselected");
                          if(serviceselected == 1) {
                            setState(() {
                              serviceselected = 0;
                            });
                          }
                          else{
                            setState(() {
                              serviceselected = 1;
                            });
                          }
                          },
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),


                    Expanded(

                      child: MaterialButton(
                        padding: EdgeInsets.all(5),
                        child: Text("at home",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur"),),
                        elevation: 0,
                        color: serviceselected == 0 ? getLightGrey() : getMateGold(),
                        onPressed: () {
                          if(serviceselected == 0) {
                            setState(() {
                              serviceselected = 1;
                            });
                          }
                          else{
                            setState(() {
                              serviceselected = 0;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ) ,

              ],
            ): Container(),








            TabBar(
              indicatorColor: Colors.black,
              unselectedLabelColor: getBlackMate(),
              labelColor: getMateGold(),
              onTap: (index){
                setState(() {
                  _selectedTabbar = index;
                });
              },
              tabs: [
                Tab(
                    icon: Icon(
                        Icons.widgets_rounded
                    )
                ),
                Tab(
                  icon: Icon(Icons.image_sharp),
                ),
                Tab(
                  icon: Icon(Icons.reviews  ),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),

            Builder(builder: (_) {
              if (_selectedTabbar == 0) {
                return itemData.isNotEmpty ? ExpansionPanelList(
                  animationDuration: Duration(milliseconds:1000),
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.all(0),

                  children: itemData.map((e){
                    return getExpansionPannel(e);
                  }).toList(),


                  expansionCallback: (int item, bool status) {

                    setState(() {

                      itemData.elementAt(item).expanded = !status;
                    });
                  },
                ) : Container();//1st custom tabBarView
              } else if (_selectedTabbar == 1) {
                return showGallery(businessid);//2nd tabView
              } else {
                return getRatingList(); //3rd tabView
              }
            }),
          ],
        ),
      ),
    );
  }

  ExpansionPanel getExpansionPannel(ItemModel idata)
  {

    return ExpansionPanel(

      body: Container(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: <Widget>[

            idata.type == 0 ?
            Column(
              children: _serviceDataMap[idata.headerItem]!.map((e){
                Map data = e as Map;

                data["isSelected"] != null ? data["isSelected"] = data["isSelected"]
                    : data["isSelected"] = false;



                    return getServiceList(data);

              }).toList(),

            ) :




        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("packages").doc(businessid).collection("package").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if(snapshot.hasData) {
              if(snapshot.data != null)
              {
                return
                Column(
                    children:snapshot.data!.docs.map((e){
                      Map data = e.data() as Map;


                      print("sasaasaddddd ${data}");

                      _packageDataMap['package']!.forEach((element) {
                        print(element['packagename']);
                      });



                      data["isSelected"] != null ? data["isSelected"] = data["isSelected"]
                          : data["isSelected"] = false;



                      return getPackageList(data);

                    }).toList(),
               );
              }
              else{
                return Container();
              }
            }
            return Container();

            }
            ),
          ],
        ),
      ),



      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(

          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),

          child: Text(
            idata.headerItem,
            style: TextStyle(
                color:idata.colorsItem,
                fontSize: 20,
                fontFamily: "ubuntub"
            ),
          ),
        );
      },
      isExpanded: idata.expanded,
    );

  }

  Widget getServiceList(dynamic e)
  {

    // return StatefulBuilder(
    //   builder: (BuildContext context1,
    //     void Function(void Function()) setState) {
    //
         return
          Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    e['servicename'],
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      fontSize: 20,

                      color: getBlackMate(),

                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Rs. ${e['price']} /-",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                        fontSize: 15,
                        color: getMateGold(),

                      ),
                    ),
                  ),

                  StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) setState) {
                      return Checkbox(
                        value: e['isSelected'],
                        activeColor: getMateGold(),
                        onChanged: (bool? value){
                          setState(() {



                            e['isSelected'] == true ? e['isSelected'] = false : e['isSelected'] = true;

                          });
                        },
                      );
                    },
                  ),


                ],
              )
            ],
          ),
        );
    //   }
    // );

  }


  Widget getPackageList(dynamic e)
  {

    // return StatefulBuilder(
    //   builder: (BuildContext context1,
    //     void Function(void Function()) setState) {
    //
    return
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  "${e['packagename']}",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    fontSize: 20,

                    color: getBlackMate(),

                  ),
                ),
              ),
            ),

            Row(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Rs. ${e['price']} /-",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      fontSize: 15,
                      color: getMateGold(),

                    ),
                  ),
                ),

                // StatefulBuilder(
                //   builder: (BuildContext context, void Function(void Function()) setState) {
                //     return Checkbox(
                //       value: e['isSelected'],
                //       activeColor: getMateGold(),
                //       onChanged: (bool? value){
                //         setState(() {
                //
                //
                //
                //           e['isSelected'] == true ? e['isSelected'] = false : e['isSelected'] = true;
                //
                //         });
                //       },
                //     );
                //   },
                // ),


                IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: getBlackMate(),
                  ),
                  onPressed: () {

                    print("dfdddd = ${e['userid']}  ${e['packageid']}");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PackageService(e['packageid'],e['userid'])));

                  },
                )


              ],
            )
          ],
        ),
      );
    //   }
    // );

  }



  Widget showGallery(String vendorid)
  {
    return Column(
      children: [

        SizedBox(
          height: 10,
        ),


        StreamBuilder(
            stream: FirebaseFirestore.instance.collection("gallery").doc(vendorid).collection("gallery").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData) {
                return SingleChildScrollView(
                    physics: new BouncingScrollPhysics(),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 3.0,
                      runSpacing: 3.0,
                      children: snapshot.data!.docs.map((e){
                        return GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                decoration: BoxDecoration(
                                    color: getLightGrey(),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          e['url']
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(2)
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }


  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  //declaration
  int _current = 0;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
    'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg',
    'https://static.businessworld.in/article/article_extra_large_image/1589448910_mKTyMh_salon_mangalore4.jpg'
  ];


  late TabController _tabController;
  int _selectedTabbar = 0;

  Set<String> _serviceCategory = Set();


  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);


    getSalonData();
    getServiceData(businessid);

  }

  int index = 0;
  Set<ItemModel> itemData = new Set();
  
  
  
  String businessid;

  _SalonDetails(this.businessid);

  Map salonData = new Map();

  List<Map> serviceData = [];

  
  void getSalonData()
  {
    FirebaseFirestore.instance.collection("business").doc(businessid).get().then((value){
      setState(() {
        salonData = value.data()!;

        salonData['homeappointment'] == 'true' ? servicelocation = 1 : servicelocation = 0;
        print("salondata = ${salonData['salonTypeInGender']}");

        if(salonData['salonTypeInGender'] == 'unisex') {
          _genderSelected = 3;
          maleFemale = 1;
        }
        else if(salonData['salonTypeInGender'] == 'male'){
          _genderSelected = 1;
          maleFemale = 1;
        }
        else if(salonData['salonTypeInGender'] == 'female'){
          _genderSelected = 2;
          maleFemale = 2;
        }
      });
    });
  }

  void getServiceData(String vendorid)
  {

    print("service gender = $maleFemale");
    _serviceDataMap.clear();
    serviceData.clear();
    _serviceCategory.clear();
    itemData.clear();
    _packageDataMap.clear();
    
    FirebaseFirestore.instance.collection("services").doc(vendorid).collection("service").where('seattype',isEqualTo: salonType == 1 ? "salon" : "treatment").get().then((value){
        value.docs.forEach((e) {
          //
          if(maleFemale == 1 && (e.data()['servicegender'] == "male" || e.data()['servicegender'] == "unisex"))
          {
            if(_serviceDataMap["${e.data()['servicecategory']}"] == null)
            {
              _serviceDataMap["${e.data()['servicecategory']}"] = [];
              _serviceDataMap["${e.data()['servicecategory']}"]!.add(e.data());

            }
            else{
              _serviceDataMap["${e.data()['servicecategory']}"]!.add(e.data());

            }

            setState(() {
              serviceData.add(e.data());

              _serviceCategory.add(e.data()['servicecategory']);

              int ptr = 0;


              // if(_serviceDataMap.isEmpty)
              // {
              //}
              itemData.forEach((element) {
                if(e.data()['servicecategory'] == element.headerItem)
                {
                  ptr = 1;
                }
              });

              if(ptr == 0)
              {
                itemData.add(
                  ItemModel(headerItem: e.data()['servicecategory'], discription: "discription", colorsItem: getBlackMate(), img: ""),
                );
              }

              ptr = 0;




              // _serviceCategory.forEach((element) {
              //   setState(() {
              //     itemData.add( ItemModel(
              //         headerItem: '${element}',
              //         discription:
              //         "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
              //         colorsItem: getBlackMate(),
              //         img: 'images/h_icon.png'
              //     ),
              //     );
              //   });
              // });
            });

          }
          else if(maleFemale == 0 && (e.data()['servicegender'] == "female" || e.data()['servicegender'] == "unisex")){
            if(_serviceDataMap["${e.data()['servicecategory']}"] == null)
            {
              _serviceDataMap["${e.data()['servicecategory']}"] = [];
              _serviceDataMap["${e.data()['servicecategory']}"]!.add(e.data());

            }
            else{
              _serviceDataMap["${e.data()['servicecategory']}"]!.add(e.data());

            }

            setState(() {
              serviceData.add(e.data());

              _serviceCategory.add(e.data()['servicecategory']);

              int ptr = 0;


              // if(_serviceDataMap.isEmpty)
              // {
              //}
              itemData.forEach((element) {
                if(e.data()['servicecategory'] == element.headerItem)
                {
                  ptr = 1;
                }
              });

              if(ptr == 0)
              {
                itemData.add(
                  ItemModel(headerItem: e.data()['servicecategory'], discription: "discription", colorsItem: getBlackMate(), img: ""),
                );
              }

              ptr = 0;




              // _serviceCategory.forEach((element) {
              //   setState(() {
              //     itemData.add( ItemModel(
              //         headerItem: '${element}',
              //         discription:
              //         "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
              //         colorsItem: getBlackMate(),
              //         img: 'images/h_icon.png'
              //     ),
              //     );
              //   });
              // });
            });

          }

        });
        
        FirebaseFirestore.instance.collection("packages").doc(vendorid).collection("package").get().then((value){

          print("jkngkf ${value.docs.first.data()}");
          if(value.docs.length != 0){


            ItemModel im = ItemModel(headerItem: "packages", discription: "discription", colorsItem: getBlackMate(), img: "");
            im.type = 1;
            itemData.add(im);


            if(_packageDataMap["package"] == null)
            {
              _packageDataMap["package"] = [];
              _packageDataMap["package"] = (value.docs.toList());

            }
            else{
              _packageDataMap["package"] = value.docs.toList();

            }
          }
        });
    });
  }



  Widget getTimeSection()
  {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds:1000),
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.all(0),

      children: [
        ExpansionPanel(
            body: salonData.length == 0 ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][0]['0']['day']}",

                          style: TextStyle(
                            color: salonData['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                            fontSize: 15,
                            fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][0]['0']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][0]['0']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )

                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),



                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][1]['1']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][1]['1']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][1]['1']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )

                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][2]['2']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][2]['2']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][2]['2']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),


                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][3]['3']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][3]['3']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][3]['3']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),



                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][4]['4']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][4]['4']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][4]['4']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),





                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][5]['5']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][5]['5']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][5]['5']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )

                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),


                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${salonData['businessTiming'][6]['6']['day']}",

                          style: TextStyle(
                              color: salonData['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${salonData['businessTiming'][6]['6']['start']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: salonData['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${salonData['businessTiming'][6]['6']['end']}",

                            style: TextStyle(
                                color: salonData['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),
                        ],
                      )

                    ],
                  ),

                ),

                SizedBox(
                  height: 10,
                ),





              ],
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return  Container(

                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),

                child: Text(
                  "Salon Time",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 20,
                      fontFamily: "ubuntub"
                  ),
                ),
              );
            },
          isExpanded: timeExpansion,
        ),
      ],

      expansionCallback: (int item, bool status) {
        setState(() {
          if(status) {
            timeExpansion = false;
          }
          else{
            timeExpansion = true;
          }
        });
      });
  }

  Widget getRatingList()
  {
    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection("business").doc(businessid)
          .collection("review").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          if(snapshot.data != null){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: snapshot.data!.docs.map((e) => getRatingContainer(e.data())).toList(),
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


  Widget getRatingContainer(Map reviewdata)
  {
    return Container(
        width: MediaQuery.of(context).size.width,

        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 30
            ),


            Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("business").doc(businessid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasData)
                      {
                        if(snapshot.data != null)
                        {
                          return Text(
                              "${snapshot.data['businessName']}",
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntub",
                                  fontSize: 15
                              )
                          );
                        }
                        else{
                          return Text("name");
                        }
                      }
                      else{
                        return Text("name");
                      }
                    },
                  ),
                ),


                RatingBar.builder(
                  initialRating: double.parse("${reviewdata['rate']}"),
                  minRating: 1,
                  itemSize: 15,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: getMateGold(),
                  ),
                  onRatingUpdate: (double value) {
                    setState(() {
                      reviewdata['rate'] = reviewdata['rate'];
                    });
                  },
                ),
              ],
            ),

            SizedBox(
              height: 15,
            ),

            Text(
                "${reviewdata['comment']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: getLightGrey2(),
                    fontFamily: "ubuntub",
                    fontSize: 12
                )
            ),


            SizedBox(
              height: 15,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              decoration: BoxDecoration(
                color: getLightGrey1(),
              ),
            ),

          ],
        )

    );
  }

  int maleFemale = 1;

  int salonType = 1;

  int _genderSelected = 0;

  bool timeExpansion = false;

  int servicelocation = 0;
  int serviceselected = 0;

  Map<String,List> _serviceDataMap = new Map();
  Map<String,List> _packageDataMap = new Map();

}

class ItemModel {
  bool expanded;
  String headerItem;
  String discription;
  Color colorsItem;
  String img;
  int type = 0;

  ItemModel({this.expanded: false, required this.headerItem, required this.discription,required this.colorsItem,required this.img});
}