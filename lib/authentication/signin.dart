import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/authentication/forgetpass.dart';
import 'package:hair/authentication/signup.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/authentication_service.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/home/user_home.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignIn extends StatefulWidget{
  String comesfrom;

  SignIn(this.comesfrom);

  _SignIn createState ()=> _SignIn(comesfrom);
}

class _SignIn extends State<SignIn>
{
  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.height / 3),bottomRight: Radius.circular(MediaQuery.of(context).size.height / 3)),
                  image: DecorationImage(
                    image: AssetImage(
                        "images/hair5.jpg"
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
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextFormField(
                          controller: _email_controller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            else if(!isEmail(value)){
                              return 'please enter valid email';
                            }

                            return null;
                          },
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20/scaleFactor,
                            fontFamily: "ubuntur",
                          ),

                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "eg: abc123@gmail.com",
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



                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextFormField(
                          controller: _password_controller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            else if(value.length < 8)
                            {
                              return 'please enter password length greater then 8';
                            }
                            return null;
                          },

                          obscureText: obscure,
                          obscuringCharacter: "*",


                          style: TextStyle(
                              color: getBlackMate(),
                              fontSize: 20/scaleFactor,
                            fontFamily: "ubuntur",
                          ),

                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "eg: password",

                            suffixIcon: IconButton(
                              color: Colors.grey,
                              icon: Icon(
                                obscure == true ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: (){

                                setState(() {
                                  if(obscure == true) {
                                    obscure = false;
                                  }
                                  else{
                                    obscure = true;
                                  }
                                });
                              },
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

                      SizedBox(
                        height: 5,
                      ),


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

                              setState(() {
                                _pointer = 1;
                              });
                              FirebaseAuthService auth = FirebaseAuthService(FirebaseAuth.instance);

                              auth.signIn(email: _email_controller.text, pass: _password_controller.text).then((value){
                                if(value == "done")
                                {
                                  setState(() {
                                    _pointer = 0;
                                  });
                                  UserCredential uc = auth.service;
                                  print(uc.user!.uid);

                                  FirebaseFirestore.instance.collection("users").doc(uc.user!.uid).get().then((
                                      value)  {
                                    if (value.data() == null) {

                                    }
                                    else {
                                      if (value.get('accounttype') == "user") {
                                        Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => NewUserHome()),
                                        );
                                      }
                                      else {
                                        Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => BarberDashboard(uc.user!.uid)),
                                        );
                                      }
                                    }
                                  }).onError((error, stackTrace) {

                                  });



                                }
                                else{
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "bad credentials",
                                        textStyle: TextStyle(
                                            fontFamily: "ubuntub",
                                            color: Colors.white,
                                            fontSize: 18
                                        ),
                                      )
                                  );
                                  print("non");
                                  setState(() {
                                    _pointer = 0;
                                  });
                                }
                              });
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
                        ) ,
                      ) : CircularProgressIndicator(),

                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20,0,20,0),

                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ForgetPass()),
                            );
                          },
                          child: Text("forgot password ?",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "ubuntur",
                              color: getBlackMate(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),


              SizedBox(
                height: 20,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Singup(comesfrom)),
                    );
                  },
                  elevation: 0,
                  child: Text(
                      "Sign up ?",
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



  //system method
  _SignIn(this.comesfrom);

  @override
  void initState() {
    _email_controller = TextEditingController();
    _password_controller = TextEditingController();
  }





  //declaration
  var _formKey = GlobalKey<FormState>();
  var _email_controller;
  var _password_controller;
  String comesfrom;
  int _pointer = 0;
  bool obscure = true;
}