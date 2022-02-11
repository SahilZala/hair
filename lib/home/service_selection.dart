
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hair/checkout/time_date_selection_new.dart';
import 'package:hair/home/at_home_booking.dart';
import 'package:hair/home/groom_bridal_salon.dart';
import 'package:hair/home/salon_list_category_vice.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:io';

import '../colors.dart';

class ServiceSelection extends StatefulWidget
{

  String seattype,servicetype,servicecategory,businessid,serviceid,comes;

  ServiceSelection(this.seattype, this.servicetype, this.servicecategory,
      this.businessid, this.serviceid,this.comes);

  _ServiceSelection createState ()=> _ServiceSelection(seattype,servicetype,servicecategory,businessid,serviceid,comes);
}

class _ServiceSelection extends State<ServiceSelection> with SingleTickerProviderStateMixin
{
  double scaleFactor = 0;

  String seattype,servicetype,servicecategory,businessid,serviceid,comes;

  _ServiceSelection(this.seattype, this.servicetype, this.servicecategory,
      this.businessid, this.serviceid,this.comes);


  Future<bool> _onWillPop() async{

    print("bldjgdnlkjvndlkjdnvdjklnl = "+seattype);
    print("bldjgdnlkjvndlkjdnvdjklnl = "+servicetype);
    print("bldjgdnlkjvndlkjdnvdjklnl = "+servicecategory);
    print("bldjgdnlkjvndlkjdnvdjklnl = "+businessid);
    print("bldjgdnlkjvndlkjdnvdjklnl = "+serviceid);
    print("bldjgdnlkjvndlkjdnvdjklnl = "+comes);


    if(comes == "slcv") {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => SalonListCategory(seattype,servicetype,servicecategory)));
    }
    else if(comes == "gob") {
      print(";negnreogjeg $comes");
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => GroomBridalListing(servicetype, seattype)));
    }
    else if(comes == "ahb")
    {
      print(";negnreogjeg $comes");
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => GroomBridalListing(servicetype, seattype)));
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;

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
                        getSalonContainer(),

                        SizedBox(height: 80,),
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: getBlackMate(),
                  title: Text(
                    "Service",
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

                            if(itemData.isNotEmpty) {

                              if(itemData[0].data[0]['isSelected'] == true) {

                                if(serviceselected == 0) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          TimeDateSelection(
                                              this.seattype, this.servicetype,
                                              this.servicecategory, this.businessid,
                                              this.serviceid,this.comes)));
                                }
                                else{
                                  print("home");

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          AtHomeBooking(
                                              this.seattype,this.servicetype == "groom" ? "male" : "female",this.businessid,[this.serviceid],comes)));
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(builder: (context) =>
                                  //         AtHomeBooking(salonType == 1
                                  //             ? "salon"
                                  //             : "treatment",
                                  //             maleFemale == 1 ? "male" : "female",
                                  //             businessid,
                                  //             serviceList)));

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

                            }
                          },
                          child: Text(
                            "CONTINUE",
                            textScaleFactor: 0.9, style: TextStyle(
                              color: getMateGold(),
                              fontSize: 18/scaleFactor
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
          getSalonDetails()
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
            color: Colors.white,
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
    return businessdetail.isNotEmpty ? Container(
      width: MediaQuery.of(context).size.width,

      child: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${businessdetail['businessName']}",
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
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: getMateGold(),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),

                Text(
                  "3.0",
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
                    "${businessdetail['address']}",
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
                              "${businessdetail["businessTiming"][index]['$index']['start']} | ${businessdetail["businessTiming"][index]['$index']['end']}",
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
              "${businessdetail['salonTypeInGender']}",
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
                physics: new BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    businessdetail.isNotEmpty ? businessdetail['businessFacilitys'][0]['0'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][1]['1'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][2]['2'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][3]['3'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][8]['8'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][9]['9'] == '1' ? Container(
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


                    businessdetail['businessFacilitys'][4]['4'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][5]['5'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][6]['6'] == '1' ? Container(
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

                    businessdetail['businessFacilitys'][7]['7'] == '1' ? Container(
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
              height: 20,
            ),

            getTimeSection(),

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


            SizedBox(
              height: 20,
            ),

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
                return ExpansionPanelList(
                  animationDuration: Duration(milliseconds:1000),

                  dividerColor: getGrey(),
                  elevation: 0,

                  children: itemData.map((e) =>  getExpansionPannel(e)).toList(),

                  expansionCallback: (int item, bool status) {

                    setState(() {
                      itemData[item].expanded = !status;
                    });
                  },
                );
              } else if (_selectedTabbar == 1) {
                return showGallery(businessid);//2nd tabView
              } else {
                return getRatingList(); //3rd tabView
              }
            }),
          ],
        ),
      ),
    ) : Container();
  }
//..
  ExpansionPanel getExpansionPannel(ItemModel itemData)
  {
    return ExpansionPanel(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: itemData.data.map((e) => getServiceList(e)).toList() ,

        ),
      ),
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          //margin: EdgeInsets.fromLTRB(0, 10, 0, 0),

          alignment: Alignment.centerLeft,
          child: Text(
            itemData.headerItem,
            style: TextStyle(
                color:getBlackMate(),
                fontSize: 20,
                fontFamily: "ubuntub"
            ),
          ),
        );
      },
      isExpanded: itemData.expanded,
    );

  }

  Widget getServiceList(dynamic e)
  {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Text(
                e['title'],
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

              Checkbox(
                value: e['isSelected'],
                activeColor: getMateGold(),
                onChanged: (bool? value){
                  setState(() {
                    //print(e['isSelected']);
                    e['isSelected'] == true ? e['isSelected'] = false : e['isSelected'] = true;
                  });
                },
              ),
            ],
          )
        ],
      ),
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

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);


    print(seattype);
    print(servicetype);
    print(servicecategory);
    print(businessid);
    print(serviceid);

    getUserName();
    getGallery();
    getBusinessDetails();
    getSalonData(serviceid);
    setHistory();

    switch(DateFormat('EEEE').format(DateTime.now()))
    {
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



  void getUserName()
  {
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value){
      setState(() {
        username = value.data()!;
        la = value.data()!['lat'] == null ? "0" : value.data()!['lat'];
        lo = value.data()!['log'] == null ? "0" : value.data()!['log'];


      });
    });
  }




  void getGallery()
  {
    imgList.clear();
    FirebaseFirestore.instance.collection("gallery")
        .doc(businessid)
        .collection("gallery")
        .get()
        .then((value){
          value.docs.forEach((element) {

            setState(() {
              imgList.add(element.data()['url']);
            });

          });
    });
  }

  void getBusinessDetails()
  {
    FirebaseFirestore.instance.collection("business").doc(businessid).get().then((value){

      setState(() {
        businessdetail = value.data()!;
      });

    });
  }

  void getSalonData(String serviceid)
  {
    FirebaseFirestore.instance.collection("services").doc(businessid)
        .collection("service").doc(serviceid).get().then((value){
      setState(() {


        value.data()!['homeappointment'] == 'true' ? servicelocation = 1 : servicelocation = 0;
        itemData.add(ItemModel(
            false,
            "${value.data()!['servicecategory']}",
            [
              {
                  'title': '${value.data()!['servicename']}',
                  'serviceid': '${value.data()!['serviceid']}',
                  'vendorid': '${value.data()!['vendorid']}',
                  'price': '${value.data()!['price']}',
                  'isSelected': false
                },
              ],
        )
        );

        setState(() {
          salonData = value.data()!;
        });

        print(salonData);
      });
    });
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



  void setHistory()
  {
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("visithistory").doc(businessid).set(
        {
          'visited': 'true',
          'salonid': businessid,
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
                          "${businessdetail['businessTiming'][0]['0']['day']}",

                          style: TextStyle(
                             color: businessdetail['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][0]['0']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][0]['0']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][0]['0']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][1]['1']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][1]['1']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][1]['1']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][1]['1']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][2]['2']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][2]['2']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][2]['2']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][2]['2']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][3]['3']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][3]['3']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][3]['3']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][3]['3']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][4]['4']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][4]['4']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][4]['4']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][4]['4']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][5]['5']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][5]['5']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][5]['5']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][5]['5']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
                          "${businessdetail['businessTiming'][6]['6']['day']}",

                          style: TextStyle(
                              color: businessdetail['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                              fontSize: 15,
                              fontFamily: "ubuntur"
                          ),
                        ),
                      ),


                      Row(
                        children: [
                          Text(
                            "${businessdetail['businessTiming'][6]['6']['start']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            " - ",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
                                fontSize: 15,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          Text(
                            "${businessdetail['businessTiming'][6]['6']['end']}",

                            style: TextStyle(
                                color: businessdetail['businessTiming'][6]['6']['activate'] == 0 ? Colors.grey : getBlackMate(),
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
          print(snapshot.data?.docs);
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
                  print(value);
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



  String la = "0",lo = "0";
  Map username = new Map();
  Map businessdetail = new Map();
  int _dayindex = 0;
  Map salonData = new Map();


  int index = 0;

  List<ItemModel> itemData = <ItemModel>[

  ];


  int servicelocation = 0;
  int serviceselected = 0;




  bool timeExpansion = false;

}

class ItemModel {
  bool expanded;
  String headerItem;
  List<dynamic> data;

  ItemModel(this.expanded, this.headerItem, this.data);
}



