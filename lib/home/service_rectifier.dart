import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/colors.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/salon_listing_from_rect.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:location/location.dart' as loc;

class ServiceRectifier extends StatefulWidget
{
  _ServiceRectifier createState ()=> _ServiceRectifier();
}

class _ServiceRectifier extends State<ServiceRectifier>
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "Filter",
              style: TextStyle(
                color: getBlackMate()
              ),
            ),
            leading: IconButton(
              onPressed: (){
                _onWillPop();
              },
              icon: Icon(
                Icons.keyboard_backspace,
                color: getBlackMate(),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text('Ratings',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'ubuntur'
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: new BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _star = 0;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _star == 0 ? getMateGold() : getLightGrey1(),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Text('1 STAR',
                                      style: TextStyle(color: getBlackMate(), fontFamily: 'Ubuntu'),)),
                              ),
                            ),
                            SizedBox(width: 12,),

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _star = 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _star == 1 ? getMateGold() : getLightGrey1(),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Text('2 STAR',
                                      style: TextStyle(color: getBlackMate(), fontFamily: 'Ubuntu'),)),
                              ),
                            ),
                            SizedBox(width: 12,),

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _star = 2;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _star == 2 ? getMateGold() : getLightGrey1(),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Text('3 STAR',
                                      style: TextStyle(color: getBlackMate(), fontFamily: 'Ubuntu'),)),
                              ),
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _star = 3;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _star == 3 ? getMateGold() : getLightGrey1(),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Text('4 STAR',
                                      style: TextStyle(color: getBlackMate(), fontFamily: 'Ubuntu'),)),
                              ),
                            ),

                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _star = 4;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _star == 4 ? getMateGold() : getLightGrey1(),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Center(
                                    child: Text('5 STAR',
                                      style: TextStyle(color: getBlackMate(), fontFamily: 'Ubuntu'),)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text('City',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'ubuntur'
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: getLightGrey(),width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: getLightGrey()
                      ),
                      child: DropdownButton<String>(
                        value: city,
                        icon: Expanded(child: Container(
                          child: Icon(Icons.arrow_drop_down,color: getMateGold(),),
                          alignment: Alignment.centerRight,)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: getBlackMate(), fontSize: 18),
                        underline: Container(
                          height: 2,
                          color: getLightGrey(),
                        ),
                        onChanged: (val) {

                          setState(() {
                            city = val!;
                          });
                        },
                        items: citySpiner.map<
                            DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text("$value",
                              textScaleFactor:0.9,
                              style: TextStyle(color: getBlackMate(),
                                  fontFamily: "ubuntur"),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20,),




                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Location', style: TextStyle(fontSize: 22, fontFamily: 'Ubuntu'),)),
                    ),

                    // Container(
                    //   margin: const EdgeInsets.all(15),
                    //   padding: const EdgeInsets.all(2),
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //       color: getLightGrey1(),
                    //       borderRadius: BorderRadius.circular(7.0)
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 15),
                    //         child: Align(
                    //             alignment: Alignment.centerLeft,
                    //             child: Text('pick current location', style: TextStyle(fontSize: 18, fontFamily: 'Ubuntu'),)),
                    //       ),
                    //       SizedBox(width: 60,),
                    //       IconButton(onPressed: (){}, icon: Icon(Icons.pin_drop, color: Colors.amber, size: 25,))
                    //     ],
                    //   ),
                    // ),


                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: EdgeInsets.fromLTRB(20, 5,20, 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: getLightGrey(),width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: getLightGrey()
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$address",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 18,
                            fontFamily: "ubuntur",

                          ),
                        ),
                      ),

                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {

                          _checkGps().then((value){
                            print("");
                          });
                          _determinePosition();
                        },
                        icon: Icon(
                          Icons.location_on_rounded,
                          color: getMateGold(),
                        ),
                      )
                    ],
                  ),
                ),


                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text('Area Cover',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Ubuntu'
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: getLightGrey(),width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: getLightGrey()
                      ),
                      child: DropdownButton<String>(
                        value: distance,
                        icon: Expanded(child: Container(
                          child: Icon(Icons.arrow_drop_down,color: getMateGold(),),
                          alignment: Alignment.centerRight,)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: getBlackMate(), fontSize: 18),
                        underline: Container(
                          height: 2,
                          color: getLightGrey(),
                        ),
                        onChanged: (val) {

                          print(distance);
                          setState(() {
                            distance = val!;
                          });
                        },
                        items: distanceSpinner.map<
                            DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == "distance" ? Text("distance",
                              textScaleFactor:0.9,
                              style: TextStyle(color: getBlackMate(),
                                  fontFamily: "ubuntur"),
                            )
                                : Text("within $value km",
                            textScaleFactor:0.9,
                            style: TextStyle(color: getBlackMate(),
                                fontFamily: "ubuntur"),
                          ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20,),

                  ],
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
                            color: getLightGrey1(),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                        ),
                     width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),

                      child: MaterialButton(
                      elevation: 0,
                        onPressed: () {
                          verifyData();
                        },

                        child: Text(
                          "rectify",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 20
                          )
                        ),


                      )
                    ),

                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }



  void _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }

      GeoCode geoCode = new GeoCode();
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) {
        debugPrint('location: ${position.latitude}');
        geoCode.reverseGeocoding(latitude: position.latitude, longitude: position.longitude).then((value) {
            setState(() {
              address = "${value.streetAddress}, ${value.city}";

              print(address);

              clat = position.latitude;
              clog = position.longitude;

              print(clat);

            });
          });
      });
    }
    catch(ex)
    {
      print("hbjf");
      print(ex);

      showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "${ex}",
            textStyle: TextStyle(
                fontFamily: "ubuntub",
                color: Colors.white,
                fontSize: 15
            ),
          )
      );
    }
  }

  void verifyData()
  {

    if(city != "city") {
      if (address != "pick your current location") {
        if (distance != "distance") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => SalonListing(city,_star,clat,clog,int.parse(distance))
          ));
        }
        else{
          showTopSnackBar(
              context,
              CustomSnackBar.success(
                message: "select distance",
                textStyle: TextStyle(
                    fontFamily: "ubuntub",
                    color: Colors.white,
                    fontSize: 15
                ),
              )
          );
        }
      }
      else {
        showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "please select location and make sure gps is on",
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15
              ),
            )
        );
      }
    }
    else{
      showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "please select city",
            textStyle: TextStyle(
                fontFamily: "ubuntub",
                color: Colors.white,
                fontSize: 15
            ),
          )
      );
    }
  }


  loc.Location location = loc.Location();//explicit reference to the Location class
  Future _checkGps() async {
    if (!await location.serviceEnabled()) {

      location.requestService();
    }
  }

  String distance = 'distance';

  List <String> distanceSpinner = [
    'distance',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '110'
  ];

  String city = 'city name';

  List <String> citySpiner = [
    'city name',
    'mumbai',
    'pune',
    'delhi',
    'any',
  ];

  String address = "pick your current location";

  double clat = 0.0,clog = 0.0;

  int _star = 0;
}