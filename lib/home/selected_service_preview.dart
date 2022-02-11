import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/barber/create_new_service.dart';
import 'package:hair/checkout/cart.dart';
import 'package:hair/checkout/group_service_check_out.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/salon_details.dart';

import '../colors.dart';

class SelectedServicePreview extends StatefulWidget{

  String salonType;
  String gender;
  String bussinesid;
  List<String> serviceid;
  String comes;

  _SelectedServicePreview createState ()=> _SelectedServicePreview(this.salonType, this.gender, this.bussinesid, this.serviceid, this.comes);

  SelectedServicePreview(
      this.salonType, this.gender, this.bussinesid, this.serviceid, this.comes);
}

class _SelectedServicePreview extends State<SelectedServicePreview>{

  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => SalonDetails(bussinesid)));

    return false;
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color: getBlackMate(),
                      ),

                      child: Column(
                        children: [
                          getSalonData(),
                        ],
                      ),
                    ),



                    Padding(
                        padding: EdgeInsets.all(15),
                        child: getTimeSection()),


                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Service list",
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20,
                            fontFamily: "ubuntub"
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Column(
                      children: serviceid.map((element) {
                        return getServiceWidget(element);
                      }).toList(),
                    ),

                    SizedBox(
                      height: 100,
                    )
                  ],
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

                      child: Container(

                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),

                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          color: getBlackMate(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery
                              .of(context)
                              .size
                              .width,

                          onPressed: () async {

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SalonCheckOut(this.salonType,this.gender,this.bussinesid,
                                        this.serviceid,comes)));
                          },
                          child: Text(
                            "CONTINUE",
                            textScaleFactor: 0.9, style: TextStyle(
                            color: getMateGold(),
                            fontSize: 18 / getScaleFactor(context),
                          ),
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        ),
                      ),
                    )
                  ],
                ),
              ),


            ],


          ),

          appBar: AppBar(
            backgroundColor: getBlackMate(),
            elevation: 0,
            title: Text(
              "Cart",
              style: TextStyle(
                  color: getLightGrey(),
                  fontFamily: "ubuntur"
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget getServiceWidget(String serviceid)
  {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("services").doc(bussinesid).collection("service").doc(serviceid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data != null){
            return Container(
              margin: EdgeInsets.fromLTRB(10,10,10,10),
              decoration: BoxDecoration(
                  color: getLightGrey(),
                  borderRadius: BorderRadius.circular(10)
              ),

              child: ListTile(

                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: getMateRed(),
                  ),
                  onPressed: () {
                    setState((){
                      this.serviceid.remove(serviceid);
                    });
                  },
                ),

                title: Text(
                  //val.service_category
                  "${snapshot.data!.data()!['servicename'].toString().toUpperCase()}",//"${snapshot.data!.data()!['businessName']}",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 18
                  ),
                ),

                subtitle: Row(
                    children: [

                      Expanded(
                        flex:1,
                        child: Text(
                          //val.service_category
                          "${snapshot.data!.data()!['servicetype'].toString()} ",//"${cartdata['servicetype']}",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              fontFamily: "ubuntur",
                              fontSize: 13
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          //val.service_category
                          "${snapshot.data!.data()!['serviceduration'].toString()} Minutes",//"${cartdata['servicetype']}",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              fontFamily: "ubuntur",
                              fontSize: 13
                          ),
                        ),
                      ),



                      Expanded(
                        flex: 3,
                        child: Text(
                          //val.service_category
                          "₹${snapshot.data!.data()!['price'].toString()} ",//"${cartdata['servicetype']}",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              fontFamily: "ubuntur",
                              fontSize: 13
                          ),
                        ),
                      ),


                    ]
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

  Widget getSalonData()
  {
    return Column(
      children: [
        SizedBox(height: 20,),

        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("business").doc(bussinesid).snapshots(),
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
                            fontSize: 25
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
                      ),

                      SizedBox(height: 15,),

                      Wrap(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][0]['0']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "MON",
                                style: TextStyle(
                                  color: salondata['businessTiming'][0]['0']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),

                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][1]['1']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "TUE",
                                style: TextStyle(
                                  color: salondata['businessTiming'][1]['1']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),


                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][2]['2']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "WED",
                                style: TextStyle(
                                  color: salondata['businessTiming'][2]['2']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),


                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][3]['3']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "THR",
                                style: TextStyle(
                                  color: salondata['businessTiming'][3]['3']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),

                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][4]['4']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "FRI",
                                style: TextStyle(
                                  color: salondata['businessTiming'][4]['4']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),

                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][5]['5']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "SAT",
                                style: TextStyle(
                                  color: salondata['businessTiming'][5]['5']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),

                          Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: getMateGold(),),
                                color: salondata['businessTiming'][6]['6']['activate'] != 1 ? getBlackMate() : getMateGold(),
                              ),

                              child: Text(
                                "SUN",
                                style: TextStyle(
                                  color: salondata['businessTiming'][6]['6']['activate'] != 1 ?  getMateGold() : getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),
                              )
                          ),



                        ],
                        spacing: 10,
                        runSpacing: 10,
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
          height: 10,
        )

      ],
    );
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

  void getSalonInfo()
  {
    FirebaseFirestore.instance.collection("business").doc(bussinesid).get().then((value){
      setState(() {
        salonData = value.data()!;

      });
    });
  }


  @override
  void initState() {
    getSalonInfo();
    super.initState();
  }

  Map salonData = new Map();

  bool timeExpansion = true;

  String salonType;
  String gender;
  String bussinesid;
  List<String> serviceid;
  String comes;

  _SelectedServicePreview(
      this.salonType, this.gender, this.bussinesid, this.serviceid, this.comes);


}