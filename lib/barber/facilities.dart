import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Facility extends StatefulWidget
{
  String vednorid;


  Facility(this.vednorid);

  _Facility createState ()=> _Facility(vednorid);
}

class _Facility extends State<Facility>
{

  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(vendorid)));
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
               body: getFacilities(),

              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  "Facility",
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                  ),
                ),

                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: getBlackMate(),
                  ),
                  onPressed: () {
                    _onWillPop();
                  },
                ),
                actions: [
                  Container(
                    height: 25,
                    width: 25,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "images/hicon3.png"
                            )
                        )
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _pointer == 0 ? Container(
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
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius:/ 5,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        minWidth: MediaQuery.of(context).size.width,

                        onPressed: () async {

                          setState(() {
                            _pointer = 1;
                          });
                          FirebaseFirestore.instance.collection("business").doc(vendorid).update({
                            'businessFacilitys': facility
                          }).then((value){

                            setState(() {
                              _pointer = 0;
                            });

                            showTopSnackBar(
                                context,
                                CustomSnackBar.success(
                                  message: "updated",
                                  textStyle: TextStyle(
                                      fontFamily: "ubuntub",
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                )
                            );
                          }).catchError((onError){
                            showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: ""+onError.toString(),
                                  textStyle: TextStyle(
                                      fontFamily: "ubuntub",
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                )
                            );
                          });
                        },
                        child: Text(
                          "UPDATE",
                          textScaleFactor: 0.9, style: TextStyle(
                            color: getMateGold(),
                            fontSize: 18/scaleFactor
                        ),
                        ),
                        color: getBlackMate(),
                        elevation: 0,
                      ),
                    ) ,
                  ) : CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget getFacilities() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
          color: Colors.white
      ),

      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(height: 10,),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  getFacility("images/ac.png","ac",0),
                  getFacility("images/parking.png","parking",1),
                  getFacility("images/wifi.png","wifi",2),
                  getFacility("images/music.png","music",3),
                  getFacility("images/sanitizer.png","sanitizer",8),
                  getFacility("images/sterilizer.png","sterilizer",9),
                  getFacility("images/online_pay.png","online payment",4),
                  getFacility("images/appointement.png","home appointment",5),
                  getFacility("images/temprature.png","temprature check",6),
                  getFacility("images/face_mask.png","face mask",7),

                ],
              ),
            ),

            SizedBox(height: 150,),
          ],
        ),
      ),
    );
  }



  Widget getFacility(String image,String title,int index)
  {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {

        return GestureDetector(
          onTap: ()
          {
            setState(() {
                if (facility.length != 0) {
                  if (facility[index][index.toString()] == '0') {
                    facility[index][index.toString()] = '1';
                  }
                  else {
                    facility[index][index.toString()] = '0';
                  }
                }
              });
            },
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: facility.length != 0 && facility[index][index.toString()] == '0' ? 1 : 10,

            child: Container(
              width: MediaQuery.of(context).size.width/3-20,


              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: facility.length != 0 && facility[index][index.toString()] == '0' ? Colors.transparent : getMateGold(),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              image,
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                  ),

                  SizedBox(height: 8,),

                  Text(
                    title,
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 14,
                        fontFamily: "ubuntur"
                    ),
                  ),



                ],
              ),
            ),
          ),
        );
      },

    );
  }


  Future<DocumentSnapshot<Map>> fetchFacilityData() async => await FirebaseFirestore.instance.collection("business").doc(vendorid).get();


  @override
  void initState() {
    fetchFacilityData().then((value){
      Map? data = value.data();

      setState(() {
        facility = data!['businessFacilitys'];

      });



    });
  }

  _Facility(this.vendorid);

  String vendorid;
  List facility = [];
  double scaleFactor = 0;
  int _pointer = 0;
}