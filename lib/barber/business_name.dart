import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/authentication/signin.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/authentication_service.dart';
import 'package:hair/firebase/create_business.dart';
import 'package:hair/firebase/create_user.dart';
import 'package:hair/firebase/services.dart';
import 'package:hair/barber/business_created.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

class BusinessDetails extends StatefulWidget{
  String comesfrom;
  CreatUser cu;
  String activity;

  _BusinessDetails createState ()=> _BusinessDetails(comesfrom,cu,activity);

  BusinessDetails(this.comesfrom, this.cu,this.activity);
}

class _BusinessDetails extends State<BusinessDetails> {


  GlobalKey<ScaffoldState> _scaffold_key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
      scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    _setup_stage = [
      getBusinesNameContainer(),
      getBusinessType(),
      getFacilities(),
      getMaleFemale(),
      getSalonTiming(),
      getCreateServie(),
      getProfileSection()
    ];


    return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              key: _scaffold_key,
              body: _setup_stage[_setup_position],
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: getBlackMate(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),


//                 actions: [
//                   MaterialButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     elevation: 0,
//                     color: Colors.white,
//                     padding: EdgeInsets.all(0),
//                     child: Text("skip",
//                       textScaleFactor: 0.9,
// style: TextStyle(
//                           color: getBlackMate(),
//                           fontFamily: "ubuntub",
//                           fontSize: 20
//                       ),
//                     ),
//                   ),
//                 ],
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
                        color: Colors.white,
                        border: Border.all(color: Colors.grey)
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (_setup_position > 0) {
                                    _setup_position = _setup_position - 1;
                                  }
                                });
                              },
                              child: _setup_position > 0 ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.navigate_before_sharp, size: 30,),
                                  SizedBox(width: 5,),
                                  Text("prev", textScaleFactor: 0.9,
                                      style: TextStyle(
                                      color: getBlackMate(),
                                      fontFamily: "ubuntur",
                                      fontSize: 22),)
                                ],
                              ) : Container(),
                            ),
                          ),
                        ),

                        //
                        // Expanded(
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       child: Text("Step 1 of 4",
                        //         style: TextStyle(
                        //           color: getMateGold(),
                        //           fontSize: 18,
                        //
                        //         ),
                        //       )
                        //     )
                        // ),


                        Expanded(
                          child: Container(

                            alignment: Alignment.centerLeft,
                            child: MaterialButton(
                              onPressed: ()  async {

                                  if (_setup_position < _setup_stage.length - 1)
                                  {
                                    if(_setup_position > 0 || _formKey.currentState!.validate())
                                    {
                                      setState(() {
                                        _setup_position = _setup_position + 1;
                                      });
                                    }
                                  }
                                  else {

                                    if(tandc == false)
                                    {
                                      getTermsAndCondition();
                                    }
                                    else {
                                      if(_pickedImage.path != "")
                                      {
                                        if (activity == "signup")
                                        {
                                          //....
                                          if (mfu > -1) {
                                            setState(() {
                                              _pointer = 1;
                                            });
                                            FirebaseAuthService fas = new FirebaseAuthService(
                                                FirebaseAuth.instance);

                                            await fas.signUp(
                                                email: creatUser.emailaddress,
                                                pass: creatUser.password).then((
                                                value) async {
                                              if (value == "done") {

                                                String businessid = Uuid().v1();

                                                creatUser.uid =
                                                    fas.service.user.uid;
                                                creatUser.pushData().then((value) {
                                                  if (value == "done") {
                                                    CreateBusiness cb = new CreateBusiness(
                                                        creatUser.uid,
                                                        businessid,
                                                        _business_name.text
                                                            .toString(),
                                                        _business_website.text
                                                            .isEmpty
                                                            ? "none"
                                                            : _business_website.text
                                                            .toString(),
                                                        category,
                                                        facility,
                                                        hmale.toString(),
                                                        tmale.toString(),
                                                        hfemale.toString(),
                                                        tfemale.toString(),
                                                        ""+staff.toString(),
                                                        mfu == 0 ? "male" : mfu == 1
                                                            ? "female"
                                                            : "unisex",
                                                        timing,
                                                        "time",
                                                        "date",
                                                        "false",
                                                      _business_gst.text.toString() == "" ? "gst" : _business_gst.text.toString(),
                                                      _business_address.text.toString(),
                                                    );
                                                    cb.pushData().then((value) {
                                                      if (value == "done") {

                                                          FirebaseFirestore.instance.collection("business").doc(creatUser.uid).update({
                                                            'lat': lat,
                                                            'log': log
                                                          });

                                                        setState(() {
                                                          _pointer = 1;
                                                        });

                                                        for(int i = 0;i<_services.length;i++)
                                                        {
                                                          cb.createServices(_services[i], Uuid().v1());
                                                        }


                                                        cb.uploadProfileImage(_pickedImage, creatUser.uid)
                                                            .then((value){
                                                          value.ref.getDownloadURL().then((value){
                                                            FirebaseFirestore.instance
                                                                .collection("users")
                                                                .doc(cb.vendorid)
                                                                .update({"profile": value.toString()});

                                                            if(galleryImage.isEmpty)
                                                            {
                                                              setState(() {
                                                                _pointer = 0;
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          BusinessCreated()),
                                                                );
                                                              });
                                                            }
                                                            for(int i = 0;i<galleryImage.length;i++)
                                                            {
                                                              String imageid = Uuid().v1();
                                                              cb.uploadSalonImage(galleryImage[i], cb.vendorid, imageid).then((value) {
                                                                value.ref.getDownloadURL().then((value){
                                                                  FirebaseFirestore.instance.collection("gallery")
                                                                      .doc(cb.vendorid)
                                                                      .collection("gallery")
                                                                      .doc(imageid)
                                                                      .set({
                                                                    "url": value,
                                                                    "name": imageid,
                                                                    "activation": "true"
                                                                  }).whenComplete(() {
                                                                    setState(() {
                                                                      _pointer = 0;
                                                                      if(galleryImage[i] == galleryImage.last) {


                                                                        Navigator
                                                                            .pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (
                                                                                  context) =>
                                                                                  BusinessCreated()),
                                                                        );
                                                                      }
                                                                    });
                                                                  });
                                                                });
                                                              });
                                                            }
                                                          });
                                                        }).catchError((error){
                                                          setState(() {
                                                            _pointer = 0;
                                                          });
                                                          showTopSnackBar(
                                                              context,
                                                              CustomSnackBar.error(
                                                                message: ""+error.toString(),
                                                                textStyle: TextStyle(
                                                                    fontFamily: "ubuntub",
                                                                    color: Colors.white,
                                                                    fontSize: 15
                                                                ),
                                                              )
                                                          );
                                                        });



                                                        //cb.createServices(services, serviceid)



                                                        // Navigator.pushReplacement(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //       builder: (context) =>
                                                        //           SignIn(
                                                        //               comesfrom)),
                                                        // );
                                                        // setState(() {
                                                        //   _pointer = 0;
                                                        // });
                                                      }
                                                      else {
                                                        setState(() {
                                                          _pointer = 0;
                                                        });
                                                        showTopSnackBar(
                                                            context,
                                                            CustomSnackBar.error(
                                                              message: "business is not created properly",
                                                              textStyle: TextStyle(
                                                                  fontFamily: "ubuntub",
                                                                  color: Colors.white,
                                                                  fontSize: 15
                                                              ),
                                                            )
                                                        );
                                                      }
                                                    });
                                                  }
                                                  else {
                                                    setState(() {
                                                      _pointer = 0;
                                                    });
                                                    showTopSnackBar(
                                                        context,
                                                        CustomSnackBar.error(
                                                          message: "some thing went wrong",
                                                          textStyle: TextStyle(
                                                              fontFamily: "ubuntub",
                                                              color: Colors.white,
                                                              fontSize: 15
                                                          ),
                                                        )
                                                    );
                                                  }
                                                });
                                              }
                                              else {
                                                setState(() {
                                                  _pointer = 0;
                                                });
                                                showTopSnackBar(
                                                    context,
                                                    CustomSnackBar.error(
                                                      message: ""+value,
                                                      textStyle: TextStyle(
                                                          fontFamily: "ubuntub",
                                                          color: Colors.white,
                                                          fontSize: 15
                                                      ),
                                                    )
                                                );

                                                print("nonon");
                                              }
                                            });
                                          }
                                          else {
                                            setState(() {
                                              _pointer = 0;
                                            });
                                            showTopSnackBar(
                                                context,
                                                CustomSnackBar.error(
                                                  message: "Please select male,female or unisex",
                                                  textStyle: TextStyle(
                                                      fontFamily: "ubuntub",
                                                      color: Colors.white,
                                                      fontSize: 15
                                                  ),
                                                )
                                            );
                                            //   _scaffold_key.currentState!
                                            //       .showSnackBar(SnackBar(
                                            //     content: Text(
                                            //       "please select male/female/unisex",
                                            //       textScaleFactor: 0.9,
                                            //       style: TextStyle(
                                            //           color: Colors.white,
                                            //           fontFamily: "ubuntur",
                                            //           fontSize: 20
                                            //       ),),
                                            //     backgroundColor: Colors
                                            //         .redAccent,));
                                            //   print("some thing incomplete");
                                            // }
                                          }
                                        }
                                        else {
                                          setState(() {
                                            _pointer = 1;
                                          });
                                          creatUser.pushData().then((value) {
                                            if (value == "done") {

                                              CreateBusiness cb = new CreateBusiness(
                                                  creatUser.uid,
                                                  "businessid",
                                                  _business_name.text
                                                      .toString(),
                                                  _business_website.text
                                                      .isEmpty
                                                      ? "none"
                                                      : _business_website.text
                                                      .toString(),
                                                  category,
                                                  facility,
                                                  "$hmale",
                                                  "$tmale",
                                                  "$hfemale",
                                                  "$tfemale",
                                                  "$staff",
                                                  mfu == 0 ? "male" : mfu == 1
                                                      ? "female"
                                                      : "unisex",
                                                  timing,
                                                  "time",
                                                  "date",
                                                  "false",
                                                _business_gst.text.toString() == "" ? "gst" : _business_gst.text.toString(),
                                                _business_address.text.toString());

                                              cb.pushData().then((value) {
                                                if (value == "done")
                                                {

                                                  FirebaseFirestore.instance.collection("business").doc(creatUser.uid).update({
                                                    'lat': lat,
                                                    'log': log
                                                  });

                                                  setState(() {
                                                    _pointer = 1;
                                                  });
                                                  for(int i = 0;i<_services.length;i++)
                                                  {
                                                    cb.createServices(_services[i], Uuid().v1());
                                                  }


                                                  cb.uploadProfileImage(_pickedImage, creatUser.uid)
                                                      .then((value){
                                                    value.ref.getDownloadURL().then((value){
                                                      FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(cb.vendorid)
                                                          .update({"profile": value.toString()});

                                                      if(galleryImage.isEmpty)
                                                      {
                                                        setState(() {
                                                          _pointer = 0;
                                                          Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      BusinessCreated()),
                                                            );
                                                          });
                                                      }
                                                      for(int i = 0;i<galleryImage.length;i++)
                                                      {
                                                        String imageid = Uuid().v1();
                                                        cb.uploadSalonImage(galleryImage[i], cb.vendorid, imageid).then((value) {
                                                          value.ref.getDownloadURL().then((value){
                                                            FirebaseFirestore.instance.collection("gallery")
                                                                .doc(cb.vendorid)
                                                                .collection("gallery")
                                                                .doc(imageid)
                                                                .set({
                                                              "url": value,
                                                              "name": imageid,
                                                              "activation": "true"
                                                            }).whenComplete(() {
                                                              setState(() {
                                                                _pointer = 0;
                                                                if(galleryImage[i] == galleryImage.last) {

                                                                  Navigator
                                                                      .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            BusinessCreated()),
                                                                  );

                                                                }
                                                              });
                                                            });
                                                          });
                                                        });
                                                      }

                                                    });
                                                  }).catchError((error){
                                                    setState(() {
                                                      _pointer = 0;
                                                    });
                                                    showTopSnackBar(
                                                        context,
                                                        CustomSnackBar.error(
                                                          message: ""+error.toString(),
                                                          textStyle: TextStyle(
                                                              fontFamily: "ubuntub",
                                                              color: Colors.white,
                                                              fontSize: 15
                                                          ),
                                                        )
                                                    );
                                                  });

                                                  //cb.createServices(services, serviceid)

                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) =>
                                                  //           SignIn(
                                                  //               comesfrom)),
                                                  // );
                                                  // setState(() {
                                                  //   _pointer = 0;
                                                  // });
                                                }
                                                else {
                                                  setState(() {
                                                    _pointer = 0;
                                                  });
                                                  showTopSnackBar(
                                                      context,
                                                      CustomSnackBar.error(
                                                        message: "business is not created properly",
                                                        textStyle: TextStyle(
                                                            fontFamily: "ubuntub",
                                                            color: Colors.white,
                                                            fontSize: 15
                                                        ),
                                                      )
                                                  );
                                                }
                                              });


                                              // cb.pushData().then((value)
                                              // {
                                              //   if (value == "done") {
                                              //     // Navigator.pushReplacement(
                                              //     //   context,
                                              //     //   MaterialPageRoute(
                                              //     //       builder: (context) =>
                                              //     //           SignIn(
                                              //     //               comesfrom)),
                                              //     // );
                                              //     setState(() {
                                              //       _pointer = 0;
                                              //     });
                                              //   }
                                              //   else {
                                              //     _scaffold_key.currentState!
                                              //         .showSnackBar(SnackBar(
                                              //           content: Text(
                                              //         "business is not created properly",
                                              //         textScaleFactor: 0.9,
                                              //         style: TextStyle(
                                              //             color: Colors.white,
                                              //             fontFamily: "ubuntur",
                                              //             fontSize: 20
                                              //         ),),
                                              //       backgroundColor: Colors
                                              //           .redAccent,));
                                              //     setState(() {
                                              //       _pointer = 0;
                                              //     });
                                              //   }
                                              // });
                                            }
                                            else {
                                              showTopSnackBar(
                                                  context,
                                                  CustomSnackBar.error(
                                                    message: "business and user is not created properly.",
                                                    textStyle: TextStyle(
                                                        fontFamily: "ubuntub",
                                                        color: Colors.white,
                                                        fontSize: 15
                                                    ),
                                                  )
                                              );
                                              setState(() {
                                                _pointer = 0;
                                              });
                                            }
                                          });
                                        }
                                      }
                                      else
                                      {
                                        showTopSnackBar(
                                            context,
                                            CustomSnackBar.error(
                                              message: "select profile image",
                                              textStyle: TextStyle(
                                                  fontFamily: "ubuntub",
                                                  color: Colors.white,
                                                  fontSize: 15
                                              ),
                                            )
                                        );
                                      }
                                    }
                                  }
                              },

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    _setup_position != _setup_stage.length-1 ?  "next" : "submit", textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: getBlackMate(),
                                      fontFamily: "ubuntur",
                                      fontSize: 22),),
                                  SizedBox(width: 5,),
                                  Icon(Icons.navigate_next_sharp, size: 30,),


                                ],
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
            _pointer == 1 ? Center(child: CircularProgressIndicator()) : Container(),
          ],
        )
    );
  }

  Widget getBusinesNameContainer() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(
                  "Step 1 of 7",
                  textScaleFactor: 0.9,
style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntur",
                    fontSize: 18,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(
                  "Business setup",
                  textScaleFactor: 0.9,
style: TextStyle(
                    color: getGrey(),
                    fontFamily: "ubuntur",
                    fontSize: 18,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(
                  "What's your business name ?",
                  textScaleFactor: 0.9,
style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 35,
                  ),
                ),
              ),


              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(
                  "This is the brand name your clients will see your billing and legal name can be added later",
                  textScaleFactor: 0.9,
style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: "ubuntur",
                    fontSize: 18,
                  ),
                ),
              ),


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
                              return 'Plea  se enter your business name';
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


                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _business_address,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }


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
                          hintText: " your address",
                          suffixIcon: IconButton(
                            onPressed: (){
                              pickAddress();
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: getBlackMate(),
                              size: 20,
                            ),
                          ),
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
                        controller: _business_gst,
                        validator: (value) {


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
                          hintText: "gst number (optional)",
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
    );
  }


  Widget getBusinessType() {
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                  "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Business setup",
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getGrey(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Choose your main business type",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 35,
                ),
              ),
            ),


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
    );
  }

  Widget getCategory(String image,String title,int index)
  {
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
      return GestureDetector(
        onTap: (){
          setState(() {
            if(category[index][index.toString()] == '0')
            {
              if(index == 0)
              {
                spinnerItems.add('salon');
              }
              else if(index == 1)
              {
                spinnerItems.add('frelancing');
              }
              else if(index == 2)
              {
                spinnerItems.add('groom');
              }
              else if(index == 3)
              {
                spinnerItems.add('bridal');
              }
              else if(index == 4)
              {
                spinnerItems.add('massage/spa');
              }

              category[index][index.toString()] = '1';
            }
            else {
              if(index == 0)
              {
                spinnerItems.remove('salon');
              }
              else if(index == 1)
              {
                spinnerItems.remove('frelancing');
              }
              else if(index == 2)
              {
                spinnerItems.remove('groom');
              }

              else if(index == 3)
              {
                spinnerItems.remove('bridal');
              }
              else if(index == 4)
              {
                spinnerItems.remove('massage/spa');
              }

              category[index][index.toString()] = '0';
            }
          });
        },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: category[index][index.toString()] == '0' ? 1 : 10,
          child: Container(
            width: MediaQuery.of(context).size.width/3-20,


            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: category[index][index.toString()] == '0' ? Colors.transparent : getMateGold(),
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
    });
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                  "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Business setup",
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getGrey(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Choose more Details of your business",
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 35,
                ),
              ),
            ),


            SizedBox(height: 30,),

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
          onTap: (){
            setState(() {
              if(facility[index][index.toString()] == '0')
              {
                facility[index][index.toString()] = '1';
              }
              else {
                facility[index][index.toString()] = '0';
              }
            });
          },
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: facility[index][index.toString()] == '0' ? 1 : 10,
            child: Container(
              width: MediaQuery.of(context).size.width/3-20,


              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: facility[index][index.toString()] == '0' ? Colors.transparent : getMateGold(),
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
      },

    );



  }


  Widget getMaleFemale() {
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Business setup",
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getGrey(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Choose category of your business",
                textScaleFactor: 0.9,
style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 35,
                ),
              ),
            ),


            SizedBox(height: 30,),

            StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      getMFU("images/male.png","male",0,setState),
                      getMFU("images/female.png","female",1,setState),
                      getMFU("images/unisex.png","unisex",2,setState),

                    ],
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  mfu == 0 || mfu == 2? Text(
                    "Male Seats",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntur",
                        fontSize: 25
                    ),
                  ) : SizedBox(),

                  mfu == 0 || mfu == 2 ? SizedBox(
                    height: 10,
                  ) : SizedBox(),

                  mfu == 0 || mfu == 2 ? Container(
                    width: MediaQuery.of(context).size.width,


                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          if(hmale > 0) {
                                            --hmale;
                                          }
                                        });
                                      }, icon:Icon(Icons.remove),

                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(

                                    child: Container(
                                        alignment: Alignment.center,

                                        child: Column(
                                          children: [
                                            Text(
                                              "hair",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 13
                                              ),
                                            ),
                                            Text(
                                              "$hmale",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 20
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),


                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          ++hmale;
                                        });
                                      }, icon:Icon(Icons.add),

                                      ),
                                    ),
                                  ),
                                ),





                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          if(tmale > 0) {
                                            --tmale;
                                          }
                                        });

                                      }, icon:Icon(Icons.remove),

                                      ),
                                    ),
                                  ),
                                ),



                                Expanded(
                                  flex: 2,
                                  child: Container(

                                    child: Container(
                                        alignment: Alignment.center,

                                        child: Column(
                                          children: [
                                            Text(
                                              "treatment",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 13
                                              ),
                                            ),
                                            Text(
                                              "$tmale",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 20
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),



                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          ++tmale;
                                        });
                                      }, icon:Icon(Icons.add),

                                      ),
                                    ),
                                  ),
                                ),



                              ],
                            ),
                          ),
                        ),





                      ],
                    ),

                  ) : SizedBox(),

                  mfu == 0 || mfu == 2 ? SizedBox(height: 20,) : SizedBox(),

                  mfu == 1 || mfu == 2 ? Text(
                    "Female Seats",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntur",
                        fontSize: 25
                    ),
                  ) : SizedBox(),

                  mfu == 1 || mfu == 2 ? SizedBox(
                    height: 10,
                  ) : SizedBox(),

                  mfu == 1 || mfu == 2 ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          if(hfemale > 0) {
                                            --hfemale;
                                          }
                                        });

                                      }, icon:Icon(Icons.remove),

                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(

                                    child: Container(
                                        alignment: Alignment.center,

                                        child: Column(
                                          children: [
                                            Text(
                                              "hair",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 13
                                              ),
                                            ),
                                            Text(
                                              "$hfemale",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 20
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          ++hfemale;
                                        });
                                      }, icon:Icon(Icons.add),

                                      ),
                                    ),
                                  ),
                                ),




                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [



                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          if(tfemale > 0) {
                                            --tfemale;
                                          }
                                        });

                                      }, icon:Icon(Icons.remove),

                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(

                                    child: Container(
                                        alignment: Alignment.center,

                                        child: Column(
                                          children: [
                                            Text(
                                              "treatment",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 13
                                              ),
                                            ),
                                            Text(
                                              "$tfemale",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 20
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),




                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          tfemale++;
                                        });
                                      }, icon:Icon(Icons.add),

                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),





                      ],
                    ),

                  ) : SizedBox(),

                  mfu == 1 || mfu == 2 ? SizedBox(height: 20,) : SizedBox(),

                  Text(
                    "Total Staff",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntur",
                        fontSize: 25
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ) ,

                  Container(

                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [


                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Container(

                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          if(staff > 0) {
                                            --staff;
                                          }
                                        });
                                      }, icon:Icon(Icons.remove),

                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(

                                    child: Container(
                                        alignment: Alignment.center,

                                        child: Column(
                                          children: [
                                            Text(
                                              "staff",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 13
                                              ),
                                            ),
                                            Text(
                                              "$staff",
                                              textScaleFactor: 0.9,
                                              style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 20
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),


                                Expanded(
                                  child: Container(

                                    child: Container(
                                      width: 20,
                                      child: IconButton(onPressed: () {
                                        setState(() {
                                          ++staff;
                                        });
                                      }, icon:Icon(Icons.add),

                                      ),
                                    ),
                                  ),
                                ),




                              ],
                            ),
                          ),
                        ),





                      ],
                    ),

                  ),

                ],
              );
            }),



            SizedBox(height: 150,),
          ],
        ),
      ),
    );
  }


  Widget getMFU(String image,String title,int index,setState)
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          mfu = index;
        });
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: mfu != index ? 1 : 10,
        child: Container(
          width: MediaQuery.of(context).size.width/3-20,


          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mfu != index ? Colors.transparent : getMateGold(),
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


  Widget getSalonTiming()
  {
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Business setup",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getGrey(),
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "Add your working hours",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 35,
                ),
              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                "These are the hours your clients can book your services.",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: "ubuntur",
                  fontSize: 18,
                ),
              ),
            ),



            SizedBox(height: 30,),

            StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
              return Column(
                children: [
                  getDaysWidget("Monday",0,setState),
                  getDaysWidget("Tuesday",1,setState),
                  getDaysWidget("Wednesday",2,setState),
                  getDaysWidget("Thursday",3,setState),
                  getDaysWidget("Friday",4,setState),
                  getDaysWidget("Saturday",5,setState),
                  getDaysWidget("Sunday",6,setState),



                ],
              );
            }),









            SizedBox(height: 150,),
          ],
        ),
      ),
    );
  }


  Widget getDaysWidget(String day,int position,setState)
  {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex:1,
              child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.centerLeft,
                child: Checkbox(
                  value: timing[position][position.toString()]['activate'] == 0 ? false : true,
                  activeColor: getMateGold(),
                  onChanged: (bool? value){
                    setState(() {
                      value == true ? timing[position][position.toString()]['activate'] = 1 : timing[position][position.toString()]['activate'] = 0;
                    });
                  },
                ),
              ),
            ),


            Expanded(
              flex:3,
              child: Text(
                "$day",
                textAlign: TextAlign.left,
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),

              ),
            ),


            Expanded(
              flex: 6,
              child: Container(

                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          _selectTime().then((value) {
                            setState(() {
                              timing[position][position.toString()]['start'] = value;
                            });
                          });
                        },
                        child: Text(
                          timing[position][position.toString()]['start'],

                          textScaleFactor: 0.9,
                          style: TextStyle(

                            color: getGrey(),

                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),

                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(
                        "---",
                        textAlign: TextAlign.center,
                        textScaleFactor: 0.9,
                      style: TextStyle(
                        color: getBlackMate()
                      ),
                      ),
                    ),

                    Expanded(
                      flex: 4,
                      child: MaterialButton(

                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _selectTime().then((value) {
                            setState(() {
                              timing[position][position.toString()]['end'] = value;
                            });
                          });
                        },
                        child: Text(
                          timing[position][position.toString()]['end'],
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getGrey(),
                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),

                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),


        SizedBox(
          height: 10,
        ),

        Container(
            height: 2,
            width: MediaQuery.of(context).size.width,
            color: getLightGrey()
        ),

      ],
    );
  }




  Future<String> _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    return "${newTime!.hour < 10 ? "0${newTime.hour}" : "${newTime.hour}"} : ${newTime.minute < 10 ? "0${newTime.minute}" : "${newTime.minute}"}";
  }



  //create services

  Widget getCreateServie()
  {
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
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Text(
                          "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Text(
                          "Business setup",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getGrey(),
                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Text(
                          "Create your service list",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntub",
                            fontSize: 35,
                          ),
                        ),
                      ),


                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Text(
                          "Create different service for your customers with different categories.",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),

                      getListOfService(),

                      SizedBox(height: 120,),
                    ]
                )
            ),

            Container(
              height: MediaQuery.of(context).size.height-190,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showDialog();
                    },
                    backgroundColor: getBlackMate(),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),


                  ),
                ],
              ),
            ),
          ],

        )

    );
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.remove,
                          color: getBlackMate(),
                          size: 30,
                        ),
                      ),
                      elevation: 0,
                    ),
                    body: SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(

                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              getTitle(),
                              getFormWidget(context,setState)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }


  Widget getTitle()
  {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(
        "Add a new service",
        style: TextStyle(
            color: getBlackMate(),
            fontFamily: "ubuntub",
            fontSize: 25

        ),
      ),
    );
  }

  int _seat_distribution = 0;
  Widget getFormWidget(BuildContext context,setStateService)
  {

    return Form(
      key: _service_form,
        child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
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
                  value: categoryValue,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
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
                    setStateService(() {
                      categoryValue = val!;
                    });
                  },
                  items: categorySpinnerItems.map<
                      DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),


              SizedBox(
                height: 20,
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
                  value: dropdownValue,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
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
                    setStateService(() {
                      dropdownValue = val!;
                    });
                  },
                  items: spinnerItems.map<
                      DropdownMenuItem<String>>((
                      String value) {

                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),



              SizedBox(height: 20,),




              Container(

                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _service_name,

                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return 'please enter service title';
                    }
                    return null;

                  },
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 20/scaleFactor
                  ),

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "service title",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2,color: getBlackMate()),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2,color: getBlackMate())
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),


              Container(

                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _service_description,
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return 'please enter description of service';
                    }
                    return null;

                  },
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 20/scaleFactor
                  ),

                  minLines: 2,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "service description",

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2,color: getBlackMate()),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2,color: getBlackMate())
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                    border: Border.all(color: getLightGrey(),width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: getLightGrey()
                ),
                child: DropdownButton<String>(
                  value: genderSelection,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
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
                    setStateService(() {
                      genderSelection = val!;
                    });
                  },
                  items: genderSpinner.map<
                      DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),


              // Container(
              //   margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              //
              //   decoration: BoxDecoration(
              //       color: getLightGrey(),
              //       borderRadius: BorderRadius.circular(10)
              //   ),
              //   width: MediaQuery.of(context).size.width,
              //   child: RaisedButton(
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              //
              //     color: getLightGrey(),
              //     padding: EdgeInsets.all(15),
              //
              //     child: Row(
              //       children: [
              //         Expanded(
              //             child: Container(
              //                 child: Text(
              //                   genderSelection,
              //                   textScaleFactor: 0.9,
              //                   style: TextStyle(
              //                       color: getBlackMate(),
              //                       fontFamily: "ubuntur",
              //                       fontSize: 18
              //                   ),
              //                 )
              //             )
              //         ),
              //
              //         Expanded(
              //           child: Container(
              //             alignment: Alignment.centerRight,
              //             child: Icon(
              //                 Icons.arrow_forward_ios_sharp
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //
              //     onPressed: (){
              //       showCupertinoModalPopup(
              //         context: context,
              //         builder: (_) => CupertinoActionSheet(
              //           actions: [
              //             CupertinoActionSheetAction(
              //                 onPressed: (){
              //                   setStateService(() {
              //                     genderSelection = "male";
              //                   });
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("male")
              //             ),
              //             CupertinoActionSheetAction(
              //                 onPressed: (){
              //                   setStateService(() {
              //                     genderSelection = "female";
              //                   });
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("female")
              //             ),
              //             CupertinoActionSheetAction(
              //                 onPressed: (){
              //                   setStateService(() {
              //                     genderSelection = "unisex";
              //                   });
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text("unisex")
              //             )
              //           ],
              //
              //           cancelButton: CupertinoActionSheetAction(
              //             child: Text("cancel"),
              //             onPressed: (){
              //               Navigator.pop(context);
              //             },
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),

              // SizedBox(height: 20,),
              //
              //
              // Container(
              //   height: 20,
              //   color: getLightGrey(),
              //   width: MediaQuery.of(context).size.width,
              // ),
              //
              // SizedBox(height: 20,),
              //
              // Container(
              //   margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Online booking",
              //         style: TextStyle(
              //           color: getBlackMate(),
              //           fontFamily: "ubuntub",
              //           fontSize: 20,
              //         ),
              //       ),
              //
              //       SizedBox(
              //         height: 10,
              //       ),
              //
              //       Text(
              //         "Enable online bookings choose who the service is available for and add a short description",
              //         textAlign: TextAlign.justify,
              //         textScaleFactor: 0.9,
              //         style: TextStyle(
              //             color: getGrey(),
              //             fontFamily: "ubuntur",
              //             fontSize: 14
              //         ),
              //
              //       )
              //     ],
              //   ),
              // ),
              //
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              //       child: SwitcherButton(
              //         value: _online_booking,
              //         offColor: getBlackMate(),
              //         onColor: getMateGold(),
              //         onChange: (value) {
              //           _online_booking = value;
              //           print(_online_booking);
              //           // setState((){
              //           //   _online_booking = value;
              //           // });
              //         },
              //       ),
              //     ),
              //
              //     Text(
              //       "Enable online bookings",
              //       style: TextStyle(
              //         color: getBlackMate(),
              //         fontFamily: "ubuntur",
              //         fontSize: 15,
              //
              //       ),
              //     ),
              //   ],
              // ),
              //
              SizedBox(
                height: 20,
              ),

              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pricing and Duration",
                      style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntub",
                        fontSize: 20,
                      ),

                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text("Add the pricing options and duration of the service.",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getGrey(),
                          fontSize: 14,
                          fontFamily: "ubuntur"
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7.5, 0),
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: getLightGrey(),width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: getLightGrey()
                            ),
                            child: DropdownButton<String>(
                              value: duartionValue,
                              icon: Expanded(child: Container(
                                child: Icon(Icons.arrow_drop_down,),
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
                                setStateService(() {
                                  duartionValue = val!;
                                });
                              },
                              items: duartionValueSpinnerItems.map<
                                  DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: value == 'duration' ? Text("$value") : Text("$value Minutes"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // Expanded(
                        //   child: Container(
                        //     margin: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                        //     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: getLightGrey(),width: 2),
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: getLightGrey()
                        //     ),
                        //     child: DropdownButton<String>(
                        //       value: pricingValue,
                        //       icon: Expanded(child: Container(
                        //         child: Icon(Icons.arrow_drop_down,),
                        //         alignment: Alignment.centerRight,)),
                        //       iconSize: 24,
                        //       elevation: 16,
                        //       style: TextStyle(
                        //           color: getBlackMate(), fontSize: 18),
                        //       underline: Container(
                        //         height: 2,
                        //         color: getLightGrey(),
                        //       ),
                        //       onChanged: (val) {
                        //         setStateService(() {
                        //           pricingValue = val!;
                        //         });
                        //       },
                        //       items: pricingCalueSpinner.map<
                        //           DropdownMenuItem<String>>((
                        //           String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(value),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),

                    SizedBox(height: 20,),

                    Container(

                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _price,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return 'please enter price';
                          }
                          return null;

                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20/scaleFactor
                        ),

                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: "price",
                          prefixIcon: Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            child: Text("₹",
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                  fontSize: 22
                              ),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 2,color: getBlackMate())
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),


              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discount",
                      style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntub",
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Enable discount service choose to give different advantages to your clients.",
                      textAlign: TextAlign.justify,
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getGrey(),
                          fontFamily: "ubuntur",
                          fontSize: 14
                      ),

                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: SwitcherButton(
                      value: _discount_on,
                      offColor: getBlackMate(),
                      onColor: getMateGold(),
                      onChange: (value) {
                          _discount_on = value;
                      },
                    ),
                  ),

                  Text(
                    "Enable discount service",
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15,

                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _discount,
                  validator: (value) {
                    if(value!.isEmpty)
                    {
                      return 'please enter discount amount';
                    }
                    return null;

                  },
                  style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 20/scaleFactor
                  ),

                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: InputDecoration(
                    hintText: "discount in amount",
                    prefixIcon: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      child: Text("₹",
                        textAlign: TextAlign.center,
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 22
                        ),
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2,color: getBlackMate()),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2,color: getBlackMate())
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),


              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home Service",
                      style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntub",
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Enable home service to give service to your client at home.",
                      textAlign: TextAlign.justify,
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getGrey(),
                          fontFamily: "ubuntur",
                          fontSize: 14
                      ),

                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: SwitcherButton(
                      value: _home_appointment,
                      offColor: getBlackMate(),
                      onColor: getMateGold(),
                      onChange: (value) {
                          _home_appointment = value;

                      },
                    ),
                  ),

                  Text(
                    "Enable home service",
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15,

                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),


              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select seat type",
                      style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntub",
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Select seat type from given.",
                      textAlign: TextAlign.justify,
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getGrey(),
                          fontFamily: "ubuntur",
                          fontSize: 14
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setStateService((){
                        _seat_distribution = 1;
                       // print("s");
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: _seat_distribution == 0 ? 1 : 10,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width/3-50,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:_seat_distribution == 0 ? Colors.transparent : getMateGold(),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "images/chair.png",
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),

                              SizedBox(height: 8,),

                              Text(
                                "salon seat",
                                textAlign: TextAlign.center,
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
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: _seat_distribution == 0 ? 10 : 1,
                      child: GestureDetector(
                        onTap: (){
                          setStateService((){
                            _seat_distribution = 0;
                          });
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width/3-30,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _seat_distribution == 0 ? getMateGold() : Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "images/treatment_chair.png",
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),

                              SizedBox(height: 8,),

                              Text(
                                "treatment seat",
                                textAlign: TextAlign.center,
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
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),


              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                width: MediaQuery.of(context).size.width,
                child: Container(

                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: getBlackMate(),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    minWidth: MediaQuery.of(context).size.width,

                    onPressed: () async {
                      if(_service_form.currentState!.validate()) {

                        if(_discount_on == true && (int.parse(_discount.text) > 0 && int.parse(_discount.text) < int.parse(_price.text)))
                        {
                          Services data = new Services.create(
                              _service_name.text,
                              dropdownValue,
                              _service_description.text,
                              categoryValue,
                              genderSelection,
                              _online_booking.toString(),
                              duartionValue,
                              pricingValue,
                              _price.text,
                              _discount_on.toString(),
                              _discount.text,
                              _home_appointment.toString(),
                              _seat_distribution == 1 ? "salon" : "treatment") ;

                          setState((){
                            _services.add(data);
                            //   dispose();
                            Navigator.pop(context);
                          });


                          _service_name.text = "";
                          _service_description.text = "";
                          _price.text = "";
                          _discount.text = "";



                        }
                        else{
                          showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: "Please enter proper discount value",
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
                      "SAVE",
                      textScaleFactor: 0.9, style: TextStyle(
                        color: getMateGold(),
                        fontSize: 18/scaleFactor
                    ),
                    ),
                    color: getBlackMate(),
                    elevation: 0,
                  ),
                ) ,
              ) ,



              //SizedBox(height: 100,),
            ],
          ),
        )
    );
  }







  //service controllers ;

  TextEditingController _service_name = new TextEditingController(),
      _service_description = new TextEditingController(),
      _price = new TextEditingController(),
      _discount  = new TextEditingController();





  GlobalKey<FormState> _service_form = new GlobalKey();
  bool _online_booking = true,_discount_on = false,_home_appointment = false;




  List<Services> _services = [];


  Widget getListOfService() {

    return Column(
      children: _services.map((e){
        return getListView(e);
      }).toList(),
    );
    // return StreamBuilder(
    //     stream: Firestore.instance.collection('services').doc(data['mobileno']).collection("service").snapshots(),
    //     builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
    //       if(snapshot.hasData) {
    //         return Column(
    //           children: snapshot.data.docs.map((e) {
    //             return getListView(e.data());
    //           }).toList(),
    //         );
    //       }
    //       else {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //     });
    //get_data();
  }

  Widget getListView(Services val) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(

          decoration: BoxDecoration(
            color: getLightGrey(),
            borderRadius: BorderRadius.circular(10)
          ),

          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                  val.service_name[0],
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub"
                ),

              ),
              foregroundColor: getBlackMate(),
            ),
            title: Text(val.service_name,
              textScaleFactor: 0.9,
              style: TextStyle(color: getBlackMate(),
                fontFamily: "ubuntur",


              ),),
            subtitle: Text(val.service_category),
          ),
        ),
        // actions: <Widget>[
        //   IconButton(onPressed: (){},
        //       icon: Icon(
        //         Icons.edit,
        //         color: getMateBlue(),
        //       )
        //   )
        // ],
        secondaryActions: <Widget>[


          IconButton(
              onPressed: (){
                setState(() {
                  _services.remove(val);
                });

              },
              icon: Icon(Icons.delete,color: getMateRed(),)
          ),

        ],
      ),
    );
  }


  Widget getProfileSection()
  {

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
        child: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Text(
                            "Step "+(_setup_position+1).toString()+" of "+(_setup_stage.length).toString(),
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntur",
                              fontSize: 18,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Text(
                            "Business setup",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getGrey(),
                              fontFamily: "ubuntur",
                              fontSize: 18,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Text(
                            "Create your gallery",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 35,
                            ),
                          ),
                        ),


                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Text(
                            "Upload your gallery and profile pictures.",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: "ubuntur",
                              fontSize: 18,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),

                        //getListOfService(),

                        getProfileImage(),

                        SizedBox(height: 20,),

                        createGallery(),

                        SizedBox(height: 120,),
                      ]
                  )
              ),]
        )
    );

    // return Container(
    //
    //   color: Colors.white,
    //   height: 700,
    //   width: 600,
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //
    //         //       child: Stack(
    //         // children: <Widget>[
    //         Card(
    //           color: Colors.white,
    //           //      height: 200,
    //           // width: 200,
    //           clipBehavior: Clip.antiAlias,
    //           child: CircleAvatar(
    //             radius: 80,
    //             child: _pickedImage == null ? Text("Picture") : null,
    //             backgroundImage:
    //             _pickedImage != null ? FileImage(_pickedImage) : null,
    //           ),
    //         ),
    //         Card(
    //           color: Colors.white,
    //           child: Align(
    //             alignment: Alignment.topCenter,
    //             child: IconButton(
    //               icon:Icon(Icons.edit),
    //               onPressed: (){
    //                 _showPickOptionsDialog();
    //               },
    //             ),
    //           ),
    //         ),
    //         Card(
    //           color: Colors.white,
    //           child:Center(
    //             child: Column(
    //               children: [
    //                 TextField(
    //                   decoration: InputDecoration(
    //                     labelText: "Name",
    //                     filled:true,
    //                   ),
    //
    //                 ),
    //                 TextField(
    //                   maxLines: 3,
    //                   decoration: InputDecoration(
    //
    //                     labelText: "Address",
    //                     filled:true,
    //                   ),
    //
    //                 ),
    //                 SizedBox(height: 130,),
    //                 RaisedButton(
    //                     textColor: Colors.white,
    //                     color: Colors.black,
    //                     child: Text('Apply',
    //                       style: TextStyle(
    //                           fontSize: 16),
    //                     ),
    //                     onPressed: (){})
    //               ],
    //             ),
    //           ),
    //         ),
    //
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget getProfileImage()
  {
    return  Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          GestureDetector(
            onTap: (){
              _showPickOptionsDialog(0);
            },
            child: Card(
              elevation: 0,
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: getLightGrey(),
                child: _pickedImage.path == "" ? Text(
                  "Add profiles \n +",
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 20,
                    fontFamily: "ubuntur"
                  ),
                  ) : null,

                backgroundImage: FileImage(_pickedImage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createGallery()
  {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,

          child: Row(
            children: [
              Expanded(
                child: Text(
                    "Gallery",
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 25,
                  ),
                ),
              ),

              Expanded(
                child: IconButton(onPressed: (){
                  _showPickOptionsDialog(1);
                },
                    alignment: Alignment.centerRight,
                    icon: Icon(
                      Icons.add,
                      color: getBlackMate(),
                      size: 25,
                    )
                ),
              )
            ],
          )
        ),

        SizedBox(
          height: 10,
        ),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 3.0,
          runSpacing: 3.0,
          children: galleryImage.map((e){
            return GestureDetector(
              onDoubleTap: (){

              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      color: getLightGrey(),
                      image: DecorationImage(
                        image: FileImage(
                          e,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.width / 3.5,
                    padding: EdgeInsets.all(5),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              galleryImage.remove(e);
                            });
                          },
                          child: Container(

                              decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                              child: Icon(
                                Icons.delete,
                                color: getBlackMate(),
                                size: 15,)
                            ,padding: EdgeInsets.all(5),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }


  _loadPicker(ImageSource source,int comes) async {

    if(comes == 0) {
      PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
      if (picked != null) {
        setState(() {
          if (comes == 0) {
            _pickedImage = File(picked.path);
          }
          else {
            setState(() {
              galleryImage.add(File(picked.path));
            });
          }
        });
        // _cropImage(File(picked.path));
      }
    }
    else {
      List<PickedFile>? picked = await ImagePicker.platform.pickMultiImage();
      if (picked != null) {
        setState(() {
            setState(() {
              for(int i = 0;i<picked.length;i++)
              {
                galleryImage.add(File(picked[i].path));
              }
            });
        });
        // _cropImage(File(picked.path));
      }
    }
   // Navigator.pop(context);
  }

  _cropImage(File picked) async {
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.red,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
      });
    }
  }

  void _showPickOptionsDialog(int comesFrom) {


    _scaffold_key.currentState!.showBottomSheet((context){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        color: getLightGrey(),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  padding: EdgeInsets.all(20),
                  elevation: 0,
                  color: Colors.white,
                  onPressed: () {
                    _loadPicker(ImageSource.gallery,comesFrom);
                    Navigator.pop(context);
                    },
                  child: Text(
                      "gallery",
                    style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 20
                    )
                  ),
                )
              ),

              comesFrom == 0 ? Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      _loadPicker(ImageSource.camera,comesFrom);
                       Navigator.pop(context);
                    },
                    child: Text(
                        "camera",
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20
                        )
                    ),
                  )
              ) : SizedBox(),

              SizedBox(
                height: 50,
              )
            ],
          ),
        ),

      );
    });

    //
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (_) => CupertinoActionSheet(
    //     actions: [
    //       CupertinoActionSheetAction(
    //           onPressed: (){
    //
    //             _loadPicker(ImageSource.gallery,comesFrom);
    //
    //             Navigator.pop(context);
    //           },
    //           child: Text("gallery")
    //       ),
    //       CupertinoActionSheetAction(
    //           onPressed: (){
    //             _loadPicker(ImageSource.camera,comesFrom);
    //             Navigator.pop(context);
    //           },
    //           child: Text("camera")
    //       ),
    //
    //     ],
    //
    //     cancelButton: CupertinoActionSheetAction(
    //       child: Text("cancel"),
    //       onPressed: (){
    //         Navigator.pop(context);
    //
    //       },
    //     ),
    //   ),
    // );



    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         ListTile(
    //           title: Text("Pick from Gallery"),
    //           onTap: () {
    //             _loadPicker(ImageSource.gallery);
    //           },
    //         ),
    //         ListTile(
    //           title: Text("Take a pictuer"),
    //           onTap: () {
    //             _loadPicker(ImageSource.camera);
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }


  void getTermsAndCondition()
  {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Container(
                  margin: EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.5,
                  padding: EdgeInsets.all(25),

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Scaffold(
                    body: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 50,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(
                                  "images/hicon2.jpeg"
                                ),
                                fit: BoxFit.cover
                              )
                            ),
                          ),


                          SizedBox(height: 10,),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),

                          SizedBox(height: 10,),

                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(25),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: getLightGrey(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                        " HAIR TERMS AND CONDITIONS"
                                            "Acceptance of terms Updated on 25-06-2020"
                                            "Please read all the terms and conditions before registering on or accessing HAIR mobile application. By using HAIR Mobile App ,"
                                            "You are bound to accept all the terms and conditions provided by the HAIR Mobile App."
                                            "These terms and conditions applicable on all HAIR Services present inside app the terms and conditions may vary  from time to time ."
                                            " Hence you are requested to refer changes in terms and conditions from time to time on notice of change given to them. "
                                            "Your continued use of the app will mean you accept and agree to such amendment. Through this application you can book slot for the services provided by HAIR. "
                                            "The user acknowledges and agrees that the user has complete responsibility while ordering services through the HAIR mobile app."
                                            "For using HAIR mobile app Terms of service are made to make you aware of your legal obligation with respect your access and usage of HAIR mobile app."
                                            "Profile management You shall be responsible for maintaining your user name and password. Use of app for more than one user is prohibited. "
                                            "You agree that any information provided is false,inaccurate or incomplete HAIR have the right to suspend, "
                                            "terminate or block your account from Hair mobile app.Don’t share your OTP (one time password) with anybody else .Once you signed up account will be permanent."
                                            "\n\n\n"
                                            "Eligibility to use You must be at least eighteen (18) years of age or above and capable of entering, performing to these terms. "
                                            "This app is available only to those who are binding to form a valid legal contract under Indian contract Act, 1872. "
                                            "If the user is minor then he /she can use this application only with supervision and guidance of their parents. "
                                            "\n\n\n"
                                            "Appointment and booking"
                                            "\n"
                                            "The user can make a request for booking a slot at the salon by confirming via the HAIR application will be confirmed by to the"
                                            "user short message service (SMS)or by any other means of communication only after the salon accepts and confirms the booking."
                                            "For booking you need to provide accurate time and date."
                                            "Deals once confirmed cannot be exchanged or returned. Once the booking has done through the app customer can or cannot cancel it ."
                                            "*Need to report the desired HAIR 10 minutes  in advance of the scheduled booking time,otherwise delay may occur. We are not responsible for such delay .HAIR will not entertain any time barred appointment."
                                            "\nHAIR shall have the right to block any member if caused more than 2 cancellations without taking any service."
                                            "\nHAIR app meant for slot booking not any service based issues."
                                            "\nThe user understands that some type of services may be suitable for users within certain age ranges and gender only unless mentioned otherwise."
                                            "\nIt is the users sole responsibility to check whether the services ordered are suitable for the intended recipient."
                                            "\nHAIR is not liable for any loss or damage of any personal belonging and reaction to skin or hair."
                                            "\nHAIR shall have the right to deny bookings if the slot is unavailable or any other reasons like festive season ."
                                            "\nHAIR shall have the right to cancel  all booking slots without any prior notification ."
                                            "\nHAIR shall have the right to deny any additional service requested rather than the app booked service."
                                            "\nAll the images used in the HAIR app are only for illustrative purpose."
                                            "\nCustomer do not have the choice of a particular Stylist/Beautician,If he or she on other assignment."
                                            "\nMembership Customer offers can not be appicable for slot booking."
                                            "\nIf the particular offer price is same or above the app booking amount then customer can book it."
                                            "\n\n Prices and payment"
                                            "\n\n All prices shown in the app may vary different cities. We recommend you to select different HAIR before making an appointment."
                                            "Prices may vary after inclusion of GST (Goods service tax) .While HAIR takes great care to keep them up to date, the final price charged to you by Hair"
                                            "salons listed may change at the time of delivery based on the latest menu and prices.HAIR reserves the right to alter the menu of the services available"
                                            "for usage on the HAIR mobile app and or the website and to delete and remove them if needed."
                                            "No online payment provided. Only counter payment."
                                            "We don’t send email bills. All credit cards, debitcards are accepted. No booking charges. "
                                            "For a combo service or any other service either you completed or not you need to pay the whole amount as promised through HAIR application &The same is applicable for CHOICE COMBOS as well."
                                            "If additional services perceive from the salon directly you need to pay the amount of relatedservice separately. We do accept only INR (Indian Rupees). "
                                            "Offers/packages need to be redeemed within stipulate duration of time or they holdexpire by default."
                                            "\nHAIR Shall have the right to withdraw the offers and advertisements displays in the HAIR mobile application without any prior notification."
                                            "For Membership Customer offers will not be conjucture with app offer."
                                            "\n\n\n Review \n\n"
                                            "You shall not comment any wordings which shall not be defamatory abusive obscene offensive sexually offensive threatening harassing racially"
                                            "offensive or illegal material, affect the feelings of other users or badly affect integrity of society."
                                            "We strictly prohibit transmitting any political content."
                                            "\n\n Outdoor service \n\n "
                                            "We do have outdoor services for Bride and Groom make up, Hairdo, saree draping etc.  . Our specialist arrives at your place through their vehicle."
                                            "Customer need not provide any transportation."
                                            "\n"
                                            "Its customer’s duty to provide an eco-friendly platform for our specialist any kind of interference due to behavior of any of the person"
                                            "from you the app holder will be liable for that .HAIR is not liable for any delay caused in arrival of specialist due to traffic or"
                                            "any unpredictable happenings. In the event you have provided incorrect contact number or address or you are unresponsive or unavailable"
                                            "for fulfillment service offered to you HAIR is not liable."
                                            "\n"
                                            "Incalculable events"
                                            "\n"
                                            "Any unforeseeable event like Hartal, Natural calamities etc. the booking will be automatically cancelled. App holder need to book for another day."
                                            "Booking priority will not apply."
                                            "\n"
                                            "Communication"
                                            "\n"
                                            "When you use of HAIR mobile application, you agree that you are communicating with HAIR through electronic records and you consent receive"
                                            "communications via electronic records from HAIR periodically and as and when required."
                                            "HAIR may communicate with you through SMS or other electronic methods."
                                            "\n"
                                            "Restrictions"
                                            "\n"
                                            "With respect to usage on HAIR mobile application or through the services, you agree that"
                                "\n·    You shall not use any false e mail/ Mobilenumber."
                                "\n·    You shall not impersonate."
                                "\n·    Shall not violate any law rules."
                                "\n·    You shall not misuse the OTP’S(One Time Password)"
                                "\n·    You agree that you are responsible for the data charges due to the use of HAIR app."
                                "\n·    Shall not be fraudulent or involve the use of counterfeit or stolen credit cards."
                                "\n·    Shall not sell or otherwise transfer your account."
                                "\n·    To solicit others to perform or participate in any unlawful acts."
                                "\n·    To infringe upon or violate our intellectual property rights or intellectual property rights of others."
                                "\n·    To upload or transmit viruses or any other type of malicious code that will or may be used that will affect any functionality of the application."
                                "\n·    To collect or track personal information of others."
                                    "\n·    User shall have no right to copy, change alter, amend, reverse, engineer de compile, reverse translate, disassemble publish disclose display or make available or in any other manner decode the HAIR mobile app and website."
                                    "\n We reserve the right to terminate your account for the violation of restrictions,HAIR  shall not be responsible for non-availability of the HAIR mobile application during the periodic maintenance operations or any unplanned suspension of access to the HAIR application that may occur due to technical reasons or for any reason beyond HAIR control.HAIR accepts no liability for any errors or omissions , with respect to any information provided to the user. You agree not to reproduce , duplicate, copy ,sell, resell or exploit any part of the  application, use of any service , or access to the application or any content provided in the application through which the service is provided , without any express written permission by HAIR .HAIR shall not be responsible for any loss incurred due to "
                                            "any data theft from the storage (server)it will come under the procedure established by law .",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: getGrey(),
                                        fontSize: 15,
                                        fontFamily: "ubuntur"
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                          Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                    value: tandc,
                                    activeColor: getMateGold(),
                                    onChanged: (bool? value){
                                      setState(() {
                                          tandc = value!;
                                          Navigator.pop(context);
                                      });

                                    },
                                  ),
                                ),

                                SizedBox(
                                  width: 10,
                                ),

                                Text(
                                    "accept t&c",
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                        color: getBlackMate(),
                                        fontFamily: "ubuntul",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                              ]
                          )

                        ],
                      ),
                    ),
                  ),
                );
              },
            )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }


  Future<void> pickAddress()
  async {
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
        Address address = new Address();

        geoCode.reverseGeocoding(
            latitude: position.latitude, longitude: position.longitude).then((
            value) {
          address = value;

          print(address);
          setState(() {
            lat = position.latitude.toString();
            log = position.longitude.toString();

            _business_address.text = address.streetAddress.toString()+","+address.postal.toString()+","+address.city.toString()+","+address.countryCode.toString();
          });
            });
        // setState(() async {
        //
        //   FirebaseFirestore.instance.collection("business").doc(userid).update({
        //     'lat': position.latitude.toString(),
        //     'log': position.longitude.toString()
        //   });
        //
        // });
      });

    }
    catch(ex)
    {
      print(ex);
    }
  }

  String lat = "lat";
  String log = "log";


  File _pickedImage = File("");

  List<File> galleryImage = [];

  String dropdownValue = 'select service type';

  List <String> spinnerItems = [
    'select service type',

  ];

  String categoryValue = 'select category type';

  List <String> categorySpinnerItems = [
    'select category type',
    'hair cut',
    'hair color',
    'shaving'
  ];


  String duartionValue = 'duration';

  List <String> duartionValueSpinnerItems = [
    'duration',
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

  String pricingValue = 'pricing type';

  List <String> pricingCalueSpinner = [
    'pricing type',
    'fixed'
  ];

  String genderSelection = "service for ?";

  List <String> genderSpinner = [
    'service for ?',
    'male',
    'female',
    'unisex'
  ];

  String comesfrom;
  int _progress_indicator = 0;

  var _setup_position = 0;
  int mfu = -1;
  int hmale = 0,tmale = 0,hfemale = 0,tfemale = 0,staff = 0;
  TimeOfDay _time = TimeOfDay(hour: 10, minute: 00);
  CreatUser creatUser;
  int _pointer = 0;
  var _business_name,_business_website,_business_address,_business_gst;

  List<Map<String,String>> category = [];
  List<Map<String,String>> facility = [];
  List<Map<String,dynamic>> timing = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _setup_stage = [];
  double scaleFactor = 0;
  String activity;

  bool tandc = false;

  @override
  void initState() {

    _business_name = TextEditingController();
    _business_website = TextEditingController();
    _business_address = TextEditingController();
    _business_gst = TextEditingController();
    _price.text = "";
    _service_description.text = "";
    _service_name.text = "";
    _discount.text = "";





    category.add({'0': '0'});
    category.add({'1': '0'});
    category.add({'2': '0'});
    category.add({'3': '0'});
    category.add({'4': '0'});


    facility.add({'0': '0'});
    facility.add({'1': '0'});
    facility.add({'2': '0'});
    facility.add({'3': '0'});
    facility.add({'4': '0'});
    facility.add({'5': '0'});
    facility.add({'6': '0'});
    facility.add({'7': '0'});
    facility.add({'8': '0'});
    facility.add({'9': '0'});

    timing.add(
        {
          '0': {
            'day':'Monday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
    );

    timing.add(
      {
        '1' : {
          'day':'Tuesday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );

    timing.add(
      {
        '2': {
          'day':'Wednesday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );

    timing.add(
      {
        '3': {
          'day':'Thursday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );

    timing.add(
      {
        '4': {
          'day':'Friday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );

    timing.add(
      {
        '5': {
          'day':'Saturday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );
    timing.add(
      {
        '6': {
          'day':'Sunday',
          'start':'start',
          'end':'end',
          'activate': 0
        }
      },
    );
  }

  _BusinessDetails(this.comesfrom,this.creatUser,this.activity);

}
