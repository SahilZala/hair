import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class BusinessName extends StatefulWidget{
  String vendorid;

  BusinessName(this.vendorid);

  _BusinessName createState ()=> _BusinessName(vendorid);
}

class _BusinessName extends State<BusinessName>
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

             getBusinesNameContainer(),

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
                             'businessWebsite': _business_website.text,
                             'businessName': _business_name.text
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
          )
      ),
    );
  }



  Widget getBusinesNameContainer() {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Business Name",
          textScaleFactor: 0.9,
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
        decoration: BoxDecoration(
            color: Colors.white
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20,),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _business_name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          // else if(!isEmail(value!)){
                          //   return 'please enter valid email';
                          // }

                          return null;
                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20/scaleFactor,
                            fontFamily: "ubuntur",
                            fontWeight: FontWeight.bold
                        ),

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "business name",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,
                                  color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 2,
                                  color: getBlackMate())
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _business_website,
                        validator: (value) {
                          // if (value!.isEmpty) {
                          //   return 'Please enter some text';
                          // }
                          // else if(!isEmail(value!)){
                          //   return 'please enter valid email';
                          // }

                          return null;
                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20/scaleFactor,
                            fontFamily: "ubuntur",
                            fontWeight: FontWeight.bold
                        ),

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "business website (optional)",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,
                                  color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 2,
                                  color: getBlackMate())
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),

              SizedBox(height: 50,)
            ],
          ),

        ),
        height: MediaQuery.of(context).size.height,
      ),

    );
  }


  @override
  void initState() {
    businessData().then((value){
      Map? data = value.data();

      setState(() {
        _business_name.text = data!['businessName'];
        _business_website.text = data['businessWebsite'];
      });


    });
  }


  String vendorid = "";

  _BusinessName(this.vendorid);
  double scaleFactor = 0;
  int _pointer = 0;

  Future<DocumentSnapshot<Map>> businessData() async => await FirebaseFirestore.instance.collection("business").doc(vendorid).get();



  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _business_name = TextEditingController(),_business_website = TextEditingController();


}