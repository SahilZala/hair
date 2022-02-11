import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/create_user.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/user_home.dart';
import 'package:hair/barber/business_name.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPCheck extends StatefulWidget
{
  String _verification_id,_mobileno,_countrycode,comesfrom;
  _OTPCheck createState ()=> _OTPCheck(_verification_id,_mobileno,_countrycode,comesfrom);

  OTPCheck(this._verification_id, this._mobileno, this._countrycode,this.comesfrom);
}

class _OTPCheck extends State<OTPCheck>
{
  @override
  Widget build(BuildContext context) {

   return Container(
     color: getLightGrey(),
     width: MediaQuery.of(context).size.width,

     child: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(height: 10,),

           Container(
             alignment: Alignment.centerLeft,
             width: MediaQuery.of(context).size.width,
             child: IconButton(
               icon: Icon(
                 Icons.arrow_back,
                 size: 30,
                 color: getBlackMate(),
               ), onPressed: () {
                 Navigator.pop(context);
              },
             ),
           ),
           SizedBox(height: 10,),



           Container(
             padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
             child: Text(
                 "verify number",
                 textScaleFactor: 0.9,
                 style: TextStyle(
                   color: getBlackMate(),
                   fontFamily: "ubuntub",
                   fontSize: 22,
                 )
             ),
           ),

           Container(
             padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
             child: Text(
               "Enter OTP received on $_countrycode $_mobileno",
               textScaleFactor: 0.9,
               style: TextStyle(
                 color: getBlackMate(),
                 fontFamily: "ubuntur",
                 fontSize: 15,
               ),
             ),
           ),

           SizedBox(height: 20,),

           _pointer == 0 ? Container(
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
                             verificationId: _verification_id, smsCode: value))
                             .then((value) async {
                           if (value.user != null) {




                             CreatUser cu = new CreatUser(value.user!.uid.toString(), "name", "lastname", "$_countrycode"+_mobileno, "email", "pass ", "$comesfrom","profile","true","mobile_number");
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
                                       _scaffoldKey.currentState!
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
                                 _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("account is pressent but still in progress",
                                   textScaleFactor: 0.9,
                                   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                   ),),backgroundColor: Colors.redAccent,));
                               }
                             });


                           }
                         });
                       } catch (e) {
                         print(e);
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
           ) : Center(child: CircularProgressIndicator()),

           SizedBox(height: 50,),

         ],
       ),
     ),
   );
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

            });
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _pointer = 0;

              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.message.toString(),textScaleFactor: 0.9,
              style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
              ),),backgroundColor: Colors.redAccent,));
            });
          },
          codeSent: (String verificationId, int? resendToken) async {
            setState(() {
              _pointer = 0;
              _verification_id = verificationId;

              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("CODE SENT",textScaleFactor: 0.9, style: TextStyle(color: getMateGold(),fontFamily: "ubuntur",fontSize: 20
              ),),backgroundColor: getBlackMate(),));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => OTPCheck(verificationId, _mobileno, _countrycode,comesfrom)));
          },
          codeAutoRetrievalTimeout: (String verificationId) async {
            setState(() {
              _verification_id = verificationId;
              _pointer = 0;

            });

          },
          timeout: Duration(
              minutes: 2
          )
      );

      return _verification_id;

    }
    on FirebaseAuthException catch(ex){
      return ex.message.toString();
    }
  }


  //system methods
  _OTPCheck(this._verification_id, this._mobileno, this._countrycode,this.comesfrom);

  //declaration
  String _verification_id,_mobileno,_countrycode,comesfrom;
  int _pointer = 0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
}