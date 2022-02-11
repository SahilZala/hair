import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/authentication/signin.dart';
import 'package:hair/firebase/authentication_service.dart';
import 'package:hair/firebase/create_user.dart';
import 'package:hair/barber/business_name.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';


class Singup extends StatefulWidget
{
  String comesfrom;

  Singup(this.comesfrom);

  _Singup createState ()=> _Singup(comesfrom);
}

class _Singup extends State<Singup>
{
  double scaleFactor = 0;
  GlobalKey<ScaffoldState> _scaffold_state = GlobalKey();

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;


    return WillPopScope(
      onWillPop: () async {

        return await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignIn(comesfrom)),
        );
      },
      child: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                key: _scaffold_state,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getHeadingText(),
                      getSignInContainer(),
                      getForm(),
                      SizedBox(height: 10,),
                      SizedBox(height: 50,),

                    ],
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn(comesfrom)),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: getBlackMate(),
                    ),
                  ),
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

                            if (_form_key.currentState!.validate())
                            {

                              CreatUser cu = new CreatUser("uid",_first_name.text.toString(),_last_name.text.toString(),_mobileno_controller.text.toString(),_emailid_controller.text.toString(),_password_controller.text.toString(),"barber","profile","true","email");

                              cu.checkUserWithEmail().then((value) async {
                                if(value.docs.length == 0)
                                {
                                  if(_check_box_value == true) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) =>
                                            BusinessDetails(comesfrom,cu,"signup")));
                                  }
                                  else{

                                    setState(() {
                                      _pointer = 1;
                                    });

                                    FirebaseAuthService fas = new FirebaseAuthService(FirebaseAuth.instance);

                                    await fas.signUp(email: _emailid_controller.text, pass: _password_controller.text).then((value) async {
                                      if(value == "done")
                                      {
                                        CreatUser cu = new CreatUser( fas.service.user.uid, _first_name.text, _last_name.text, _mobileno_controller.text, _emailid_controller.text, _password_controller.text, comesfrom,"profile","true","email");
                                        cu.pushData().then((value){
                                          if(value == "done")
                                          {
                                            Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) => SignIn(comesfrom)),
                                            );


                                            setState(() {
                                              _pointer = 0;
                                            });
                                          }
                                          else {

                                            showTopSnackBar(
                                                context,
                                                CustomSnackBar.error(
                                                  message: "$value",
                                                  textStyle: TextStyle(
                                                      fontFamily: "ubuntub",
                                                      color: Colors.white,
                                                      fontSize: 15
                                                  ),
                                                )
                                            );

                                            // _scaffold_state.currentState!.showSnackBar(SnackBar(content: Text("$value",textScaleFactor: 0.9,
                                            //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                            //   ),),backgroundColor: Colors.redAccent,));


                                            setState(() {
                                              _pointer = 0;
                                            });
                                          }
                                        });

                                      }
                                      else {

                                        showTopSnackBar(
                                            context,
                                            CustomSnackBar.error(
                                              message: "$value",
                                              textStyle: TextStyle(
                                                  fontFamily: "ubuntub",
                                                  color: Colors.white,
                                                  fontSize: 15
                                              ),
                                            )
                                        );

                                        //
                                        // _scaffold_state.currentState!.showSnackBar(SnackBar(content: Text("$value",textScaleFactor: 0.9,
                                        //   style: TextStyle(color: Colors.white,fontFamily: "ubuntur",fontSize: 20
                                        //   ),),backgroundColor: Colors.redAccent,));

                                        setState(() {
                                          _pointer = 0;
                                        });
                                        print("nonon");
                                      }
                                    });

                                  }
                                }
                                else{
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "mail is already present",
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

                            // Navigator.push(context,
                            //   MaterialPageRoute(builder: (context) => CheckOut()),
                            // );

                            //placeOrder();
                          },
                          child: Text(
                            "CONTINUE",
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
              ) ,
            ],
          )
      ),
    );
  }

  Widget getHeadingText()
  {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Text(
            "Create Your \nAccount. ",
            textScaleFactor: 0.9, style: TextStyle(
              color: getBlackMate(),
              fontFamily: "ubuntur",
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }


  Widget getSignInContainer()
  {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "if you are already done /",
            textScaleFactor: 0.9,
            style: TextStyle(
                color: getGrey(),
                fontFamily: "ubuntur",
                fontSize: 15,
            ),
          ),


          MaterialButton(
            onPressed: (){

            },
            elevation: 0,
            padding: EdgeInsets.all(0),
            child: Text(
              "Signin",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getForm()
  {
    return Form(
      key: _form_key,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: _first_name,
              validator: (value) {
                if(value!.isEmpty)
                {
                  return 'please enter username';
                }
                return null;

              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),

              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "first name",
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
              controller: _last_name,
              validator: (value) {
                if(value!.isEmpty)
                {
                  return 'please enter lastname';
                }
                return null;
                
              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),

              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "last name",
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
              controller: _mobileno_controller,
              maxLength: 10,
              validator: (value) {
                if(value!.isEmpty)
                {
                  return 'please enter mobileno';
                }
                else if(value.length < 10){
                  return 'incomplete mobileno';
                }
                return null;

              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),

              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "mobileno",
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
              controller: _emailid_controller,
              validator: (value) {

                if(value!.isEmpty)
                {
                  return 'please enter emailaddres';
                }
                else if(!isEmail(value)){
                  return 'please enter valid email';
                }
                return null;

              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),

              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "email address",
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

                if(value!.isEmpty)
                {
                  return 'please enter password';
                }
                else if(value.length < 8)
                {
                  return 'password length mustbe greater then 8';
                }
                return null;
              },
              obscureText: obscure,
              obscuringCharacter: "*",
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),

              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
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

                hintText: "password",
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
              controller: _confirm_password_controller,
              obscureText: obsecure_new,
              obscuringCharacter: "*",
              validator: (value) {
                if(value!.isEmpty)
                {
                  return 'please enter password';
                }
                else if(value.length < 8)
                {
                  return 'password length mustbe greater then 8';
                }
                else if(value != _password_controller.text){
                  return 'password is not match with earlier password';
                }
              },
              style: TextStyle(
                  color: getBlackMate(),
                  fontSize: 20/scaleFactor
              ),
              //keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    obsecure_new == true ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: (){

                    setState(() {
                      if(obsecure_new == true) {
                        obsecure_new = false;
                      }
                      else{
                        obsecure_new = true;
                      }
                    });
                  },
                ),
                hintText: "re-enter password",
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
            margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                comesfrom == "barber" ? Text(
                  "Are You Barber ?",
                  style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 18,
                    fontFamily: "ubuntur",

                  ),

                ) : Container( ),
                comesfrom == "barber" ? Checkbox(
                  activeColor: getMateGold(),
                  value: _check_box_value,
                  onChanged: (bool? value) {
                    // setState(() {
                    //   _check_box_value = value!;
                    // });
                  },
                ) : Container(),
              ],
            ),
          ),

        ],
      ),
    );
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }





  var _form_key = GlobalKey<FormState>();

  _Singup(this.comesfrom);


  @override
  void initState() {

    comesfrom == "barber" ? _check_box_value = true : _check_box_value = false;

    _first_name = TextEditingController();
    _last_name = TextEditingController();
    _mobileno_controller = TextEditingController();
    _emailid_controller = TextEditingController();
    _password_controller = TextEditingController();
    _confirm_password_controller = TextEditingController();
  }



  var _first_name;
  var _last_name;
  var _mobileno_controller;
  var _emailid_controller;
  var _password_controller;
  var _confirm_password_controller;
  bool _check_box_value = false;
  int _pointer = 0;
  String comesfrom;

  bool obscure = true;
  bool obsecure_new = true;

  //
  // void getData(){
  //   var client = http.get(Uri.parse("http://192.168.29.195:5000/api/users"));
  //   client.then((value){
  //     print(value.body);
  //   });
  // }

}

