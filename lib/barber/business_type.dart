import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../getScaleFactor.dart';

class BusinessType extends StatefulWidget
{
  String vendorid;

  BusinessType(this.vendorid);

  _BusinessType createState ()=> _BusinessType(vendorid);
}

class _BusinessType extends State<BusinessType>
{
  String vendorid;


  _BusinessType(this.vendorid);

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
              getBusinessType(),

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
                              'businessTypeList': category
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
                                        fontSize: 15/getScaleFactor(context)
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
          )
      ),
    );
  }


  Widget getBusinessType() {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Business Type",
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
            color: Colors.white
        ),

        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              SizedBox(height: 30,),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    getCategory("images/salon.png","salon",0),
                    getCategory("images/groom.png","groom",2),
                    getCategory("images/bridal.png","bridal",3),
                    getCategory("images/massage.png","massage/spa",4),
                    getCategory("images/freelancer.png","freelancer",1),

                  ],
                ),
              ),



              SizedBox(height: 150,),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCategory(String image,String title,int index)
  {

    return GestureDetector(
        onTap: (){
          setState(() {
            if(category.length != 0 && category[index][index.toString()] == '0')
            {
              category[index][index.toString()] = '1';
            }
            else {
              category[index][index.toString()] = '0';
            }
          });
        },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: category.length != 0 && category[index][index.toString()] == '0' ? 1 : 10,
          child: Container(
            width: MediaQuery.of(context).size.width/3-20,


            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: category.length != 0 && category[index][index.toString()] == '0' ? Colors.transparent : getMateGold(),
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
                )

              ],
            ),
          ),
        ),
      );

  }

  @override
  void initState() {
    businessData().then((value){
      setState(() {
        Map? data = value.data();
        category = data!['businessTypeList'];
      });
    });
  }

  List category = [];

  Future<DocumentSnapshot<Map>> businessData() async => await FirebaseFirestore.instance.collection("business").doc(vendorid).get();

  int _pointer = 0;

  double scaleFactor = 0;
}