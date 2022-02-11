import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/authentication/otp_check.dart';
import 'package:hair/authentication/signin.dart';
import 'package:hair/authentication/signup.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/firebase/create_user.dart';
import 'package:hair/home/new_new_user_home.dart';

import 'package:hair/home/user_home.dart';
import 'package:hair/barber/business_name.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../colors.dart';

class MobileOtp extends StatefulWidget
{
  String comesfrom;

  MobileOtp(this.comesfrom);

  _MobileOtp createState ()=> _MobileOtp(comesfrom);
}

class _MobileOtp extends State<MobileOtp>
{
  @override
  Widget build(BuildContext context) {

    final double scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    return  SafeArea(
      child: Scaffold(
        key: _scaffold_key,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(180),bottomRight: Radius.circular(180)),
                    image: DecorationImage(
                        image: AssetImage(
                            "images/signin.jpg"
                        ),
                        fit: BoxFit.cover
                    )
                ),
              ),


              SizedBox(
                height: 15,
              ),

              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  "Welcome back",
                  textScaleFactor: 0.9,
                        style: TextStyle(
                      color: getBlackMate(),
                      fontSize: 25,
                      fontFamily: "ubuntub",

                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  "Choose, Book, Done",
                  textScaleFactor: 0.9,
                        style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 20,
                    fontFamily: "ubuntur",


                  ),
                ),
              ),


              SizedBox(height: 20,),


              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(

                              child: CountryCodePicker(
                                onChanged: (val){
                                  print(val);
                                  _country_code = val.toString();
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'IN',
                                favorite: ['+91','IN'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                              decoration: BoxDecoration(border: Border.all(width: 2,color: getBlackMate()),borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.fromLTRB(2,2, 2, 2),
                            ),


                            SizedBox(width: 10,),


                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: TextFormField(
                                  controller: _mobile_controller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter mobileno';
                                    }
                                    else if(value.length < 10){
                                      return 'incomplete mobileno';
                                    }

                                    return null;
                                  },

                                  style: TextStyle(
                                    color: getBlackMate(),
                                    fontSize: 20/scaleFactor,
                                    fontFamily: "ubuntur",
                                  ),

                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "eg: 11111xxxxx",
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
                            ),
                          ],
                        ),
                      ),
                      //
                      //
                      // show_otp_box == 1 ? Container(
                      //   padding: EdgeInsets.fromLTRB(20,0, 20, 10),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20)
                      //   ),
                      //   child: TextFormField(
                      //     controller: _otp_controller,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Please enter otp';
                      //       }
                      //       else if(value.length < 4)
                      //       {
                      //         return 'incorrect otp';
                      //       }
                      //       return null;
                      //     },
                      //     style: TextStyle(
                      //       color: getBlackMate(),
                      //       fontSize: 20,
                      //       fontFamily: "ubuntur",
                      //     ),
                      //
                      //     maxLength: 6,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     decoration: InputDecoration(
                      //       hintText: "otp: xxxx11",
                      //       enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(width: 2,color: getBlackMate()),
                      //           borderRadius: BorderRadius.circular(10)
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //           borderSide: BorderSide(width: 2,color: getBlackMate())
                      //       ),
                      //     ),
                      //   ),
                      // ) : Container(),


                      //
                      // SizedBox(
                      //   height: 5,
                      // ),

                      show_otp_box == 1 ?  Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Form(
                              child: PinCodeTextField(
                                keyboardType: TextInputType.number,
                                backgroundColor: Colors.transparent,
                                appContext: context,
                                length: 6,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderWidth: 2,
                                  borderRadius: BorderRadius.circular(5),
                                  activeColor: getBlackMate(),
                                  inactiveColor: Colors.grey,
                                  selectedColor: getBlackMate(),
                                  fieldHeight: 70,
                                  fieldWidth: 50,
                                ),mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                onCompleted: (value)
                                async {
                                  try {
                                    setState(() {
                                      _pointer = 1;
                                    });

                                    await FirebaseAuth.instance
                                        .signInWithCredential(PhoneAuthProvider.credential(
                                        verificationId: vid, smsCode: value))
                                        .then((value) async {
                                      if (value.user != null) {




                                        CreatUser cu = new CreatUser(value.user!.uid.toString(), "name", "lastname", "$_country_code"+_mobile_controller.text, "email", "pass ", "$comesfrom","profile","true","mobile_number");
                                        cu.checkUser().then((value)
                                        {
                                          if(value == "reg")
                                          {
                                            if(comesfrom == "user")
                                            {
                                              setState(() {
                                                _pointer = 0;
                                              });
                                              cu.pushData().then((value) {
                                                if (value == "done") {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewUserHome()));
                                                }
                                                else {
                                                  setState(() {
                                                    _pointer = 0;
                                                  });
                                                  _scaffold_key.currentState!
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "some thing wrong try latter",
                                                      textScaleFactor: 0.9,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "ubuntur",
                                                          fontSize: 20
                                                      ),),
                                                    backgroundColor: Colors
                                                        .redAccent,));
                                                }
                                              });
                                            }
                                            else{
                                              setState(() {
                                                _pointer = 0;
                                              });
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessDetails(comesfrom,cu,"mobileno")));

                                              // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",textScaleFactor: 0.9,
                                              //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                              //   ),),backgroundColor: Colors.redAccent,));
                                            }
                                          }
                                          else if(value == "user"){
                                            setState(() {
                                              _pointer = 0;
                                            });
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => NewUserHome()));
                                          }
                                          else if(value == "barber") {
                                            setState(() {
                                              _pointer = 0;
                                            });
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                                builder: (context) =>
                                                    BarberDashboard(cu.uid)));
                                          }
                                        });


                                      }
                                      else{
                                        print("sasahsialadksmdbbnvbngbgbgbgbgng");
                                        print(value);
                                      }
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _pointer = 0;
                                    });

                                    print("sasahsialadksmdbbnvbngbgbgbgbgng");
                                    print(e);
                                    _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("wrong otp",textScaleFactor: 0.9,
                                      style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                      ),),backgroundColor: Colors.redAccent,));

                                  }
                                }, onChanged: (String value) {
                                },
                              ),
                            ),


                            SizedBox(
                              height: 10,
                            ),


                            // Container(
                            //
                            //   width: MediaQuery.of(context).size.width,
                            //
                            //   padding: EdgeInsets.fromLTRB(5,5,5,5),
                            //   child: GestureDetector(
                            //
                            //     onTap: (){
                            //       mobileOtpVerification(_mobileno, _countrycode);
                            //     },
                            //
                            //     child: Text(
                            //         "Resend OTP in",
                            //         textScaleFactor: 0.9,style: TextStyle(
                            //           color: Colors.blue,
                            //           fontFamily: "ubuntur",
                            //           fontSize: 18,
                            //         )
                            //     ),
                            //   ),
                            // ),

                          ],
                        ),
                      ) : Container(),


                      _pointer == 0 ? Container(

                        margin: EdgeInsets.all(20),

                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: getBlackMate(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 5,
                          //     blurRadius: 7,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery.of(context).size.width,

                          onPressed: (){
                            if(_formKey.currentState!.validate())
                            {
                              mobileOtpVerification(_mobile_controller.text, _country_code);
                            }
                          },
                          child: Text(
                            "Sign in",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getMateGold(),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "ubuntur",
                            ),
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        )


                        // ) : MaterialButton(
                        //   padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        //   minWidth: MediaQuery.of(context).size.width,
                        //
                        //   onPressed: () async {
                        //     if(_formKey.currentState!.validate())
                        //     {
                        //       print(vid);
                        //       try {
                        //         setState(() {
                        //           _pointer = 1;
                        //         });
                        //         await FirebaseAuth.instance
                        //             .signInWithCredential(PhoneAuthProvider.credential(
                        //             verificationId: vid, smsCode: _otp_controller.text))
                        //             .then((value) async {
                        //           if (value.user != null) {
                        //             setState(() {
                        //               show_otp_box = 0;
                        //               _pointer = 0;
                        //             });
                        //
                        //
                        //             CreatUser cu = new CreatUser(value.user!.uid.toString(), "name", "lastname", ""+_mobile_controller.text, "email", "pass ", "$comesfrom","profile","true","mobile_number");
                        //             cu.checkUser().then((value)
                        //             {
                        //               if(value == "reg")
                        //               {
                        //
                        //                 setState(() {
                        //                   _pointer = 1;
                        //                 });
                        //
                        //                 cu.pushData().then((value){
                        //                   if(value == "done")
                        //                   {
                        //
                        //                     setState(() {
                        //                       _pointer = 0;
                        //                     });
                        //                     if(comesfrom == "user")
                        //                     {
                        //                         Navigator.pushReplacement(
                        //                             context,
                        //                             MaterialPageRoute(builder: (context) => UserHome()));
                        //
                        //                     }
                        //                     else{
                        //                         _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                        //                         ),),backgroundColor: Colors.redAccent,));
                        //                     }
                        //                   }
                        //                   else {
                        //                       _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("some thing wrong try latter",style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                        //                       ),),backgroundColor: Colors.redAccent,));
                        //
                        //                     setState(() {
                        //                       _pointer = 0;
                        //                     });
                        //                   }
                        //                 });
                        //
                        //
                        //                 // print("rerrdff");
                        //                 // if(comesfrom == "user")
                        //                 // {
                        //                 //   Navigator.pushReplacement(
                        //                 //       context,
                        //                 //       MaterialPageRoute(builder: (context) => UserHome()));
                        //                 // }
                        //                 // else {
                        //                 //   _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                        //                 //   ),),backgroundColor: Colors.redAccent,));
                        //                 // }
                        //               }
                        //               else if(value == "user"){
                        //                 Navigator.pushReplacement(
                        //                     context,
                        //                     MaterialPageRoute(builder: (context) => UserHome()));
                        //               }
                        //               else if(value == "barber") {
                        //                 _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                        //                 ),),backgroundColor: Colors.redAccent,));
                        //               }
                        //             });
                        //
                        //           }
                        //         });
                        //       } catch (e) {
                        //         print(e);
                        //       }
                        //     }
                        //   },
                        //   child: Text(
                        //     "verify otp",
                        //     style: TextStyle(
                        //       color: getMateGold(),
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //       fontFamily: "ubuntur",
                        //     ),
                        //   ),
                        //   color: getBlackMate(),
                        //   elevation: 0,
                        // ),
                      ) : CircularProgressIndicator(),
                    ],
                  )
              ),


              SizedBox(
                height: 50,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn(comesfrom)),
                    );
                  },
                  elevation: 0,
                  child: Text(
                    "Sign in with email ?",
                    textScaleFactor: 0.9,
                        style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 20,
                        fontFamily: "ubuntub",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
      ),
    );
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }


  Future<String> mobileOtpVerification(String mobileno,String countryCode)
  async {

    setState(() {
      _pointer = 1;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '$countryCode $mobileno',
          verificationCompleted: (PhoneAuthCredential credential) {
            setState(() {
              _pointer = 0;
              show_otp_box = 1;
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _pointer = 0;
              show_otp_box = 0;
              _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text(e.message.toString(),textScaleFactor: 0.9,
                        style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
              ),),backgroundColor: Colors.redAccent,));
            });
          },
          codeSent: (String verificationId, int? resendToken) async {
            setState(() {
              _pointer = 0;
              vid = verificationId;
              show_otp_box = 1;
              // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("CODE SENT",textScaleFactor: 0.9,
              //           style: TextStyle(color: getMateGold(),fontFamily: "ubuntur",fontSize: 20
              // ),),backgroundColor: getBlackMate(),));
            });

           // _scaffold_key.currentState!.showBottomSheet((context) => OTPCheck(verificationId, _mobile_controller.text.toString(), _country_code,comesfrom));
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => OTPCheck(verificationId, _mobile_controller.text.toString(), _country_code,comesfrom)));
          },
          codeAutoRetrievalTimeout: (String verificationId) async {
            setState(() {
              vid = verificationId;
              _pointer = 0;
              show_otp_box = 0;
            });

          },
          timeout: Duration(
              minutes: 2
          )
      );

      return vid;

    }
    on FirebaseAuthException catch(ex){
      return ex.message.toString();
    }
  }




  //system methods

  _MobileOtp(this.comesfrom);


  @override
  void initState() {
    _mobile_controller = TextEditingController();
    _otp_controller = TextEditingController();
  }

  //declaration
  var _formKey = GlobalKey<FormState>();
  var _mobile_controller;
  var _otp_controller;

  String comesfrom;
  int _pointer = 0;
  int show_otp_box = 0;
  String _country_code="+91";
  String vid = "none";

  var _scaffold_key = GlobalKey<ScaffoldState>();

}