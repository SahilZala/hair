import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/authentication/mobile_otp.dart';
import 'package:hair/authentication/signin.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/authentication_service.dart';
import 'package:hair/firebase/create_user.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/user_home.dart';

import 'package:hair/barber/business_name.dart';

class LoginPage extends StatefulWidget{
  String comesfrom;

  LoginPage(this.comesfrom);

  _LoginPage createState ()=> _LoginPage(comesfrom);
}

class _LoginPage extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold_key,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "images/login.jpg"
                      ),
                      fit: BoxFit.cover
                  )
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black54
              ),
            ),


            Container(
              margin: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                   width: 50,
                   height: 50,
                   padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("images/hicon4.png"),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 15,),

                  Text(
                      "Experience or explore a new world of style",
                    textScaleFactor: 0.9,
                        style: TextStyle(
                      color: Colors.white,
                      fontFamily: "ubuntur",
                      fontSize: 22
                    ),
                  ),


                  SizedBox(height: 15,),

                  Container(
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: getMateGold(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(comesfrom)));

                      },

                      child: Text(
                        "Login With Username",

                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "ubuntur",
                          fontSize: 18
                        ),
                      ),

                    ),
                  ),


                  SizedBox(height: 15,),

                  Container(
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: getBlackMate(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MobileOtp(comesfrom)));
                      },

                      child: Text(
                        "Login With Mobile",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "ubuntur",
                            fontSize: 18
                        ),
                      ),

                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            onPressed: (){
                              FirebaseAuthService fas = new FirebaseAuthService(FirebaseAuth.instance);
                              fas.linkGoogle().then((value){


                                print(value);

                                CreatUser cu = new CreatUser(value.user!.uid.toString(), value.additionalUserInfo!.profile!['given_name'], value.additionalUserInfo!.profile!['family_name'], "mobileno", value.additionalUserInfo!.profile!['email'], "pass", "$comesfrom",value.additionalUserInfo!.profile!['picture'],"true","google");
                                cu.checkUser().then((value)
                                {
                                  if(value == "reg")
                                  {
                                    if(comesfrom == "user")
                                    {
                                      cu.pushData().then((value) {
                                        if (value == "done") {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewUserHome()));
                                        }
                                        else {
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
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessDetails(comesfrom,cu,"google")));

                                      // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",textScaleFactor: 0.9,
                                      //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                      //   ),),backgroundColor: Colors.redAccent,));
                                    }
                                  }
                                  else if(value == "user"){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewUserHome()));
                                  }
                                  else if(value == "barber") {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => BarberDashboard(cu.uid)));
                                    // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("account is pressent but still in progress",textScaleFactor: 0.9,
                                    //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                    // ),),backgroundColor: Colors.redAccent,));
                                  }
                                });
                              }).catchError((onError){
                                _scaffold_key.currentState!
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    ""+onError.toString(),
                                    textScaleFactor: 0.9,
                                     style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ubuntur",
                                        fontSize: 20
                                    ),),
                                  backgroundColor: Colors
                                      .redAccent,));
                              });
                            },

                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "images/google_icon.png"
                                        )
                                    )
                                ),
                              )


                          ),
                        ),

                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            onPressed: (){

                              FirebaseAuthService fas = new FirebaseAuthService(FirebaseAuth.instance);
                              fas.signInWithFacebook().then((value){


                                print(value);

                                CreatUser cu = new CreatUser(value.user!.uid.toString(), value.additionalUserInfo!.profile!['first_name'], value.additionalUserInfo!.profile!['last_name'], "mobileno", value.additionalUserInfo!.profile!['email'].toString(), "pass", "$comesfrom","none","true","facebook");
                                cu.checkUser().then((value)
                                {
                                  if(value == "reg")
                                  {
                                    if(comesfrom == "user")
                                    {
                                      cu.pushData().then((value) {
                                        if (value == "done") {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewUserHome()));
                                        }
                                        else {
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
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessDetails(comesfrom,cu,"facebook")));

                                      // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("barber still in porgress",textScaleFactor: 0.9,
                                      //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                      //   ),),backgroundColor: Colors.redAccent,));
                                    }
                                  }
                                  else if(value == "user"){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewUserHome()));
                                  }
                                  else if(value == "barber") {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => BarberDashboard(cu.uid)));
                                    // _scaffold_key.currentState!.showSnackBar(SnackBar(content: Text("account is pressent but still in progress",textScaleFactor: 0.9,
                                    //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                    //   ),),backgroundColor: Colors.redAccent,));
                                  }
                                });
                              });

                            },

                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "images/facebook_icon.png"
                                  )
                                )
                              ),
                            )
                          ),
                        ),

                      )
                    ],
                  )

                ],
              )
            ),
          ],
        )
    );
  }


  //system methods
  _LoginPage(this.comesfrom);


  //declaration
  String comesfrom;
  var _scaffold_key = GlobalKey<ScaffoldState>();
}