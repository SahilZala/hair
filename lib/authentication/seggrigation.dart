
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/authentication/login.dart';
import 'package:hair/authentication/signin.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/firebase/authentication_service.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/intro_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class Segrigation extends StatefulWidget
{
  _Segrigation createState ()=> _Segrigation();
}

class _Segrigation extends State<Segrigation>
{

  @override
  void initState() {

    //askForPermission();
    setupInteractedMessage();



    if(FirebaseAuth.instance.currentUser != null)
    {
      _registerOnFirebase();

      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
        Map? data = value.data();
        if(data!['accounttype'] == 'barber')
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => BarberDashboard(FirebaseAuth.instance.currentUser!.uid)));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => NewUserHome()));
        }
      });
    }
    else{


    }

  }
  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async {
       Navigator.pop(context);
      return false;
     },
     child: Scaffold(
       body: Stack(
         children: [
           Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage(
                   "images/segimage.jpg"
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

           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Row(
                 children: [
                   Expanded(
                       child: GestureDetector(
                         onTap: (){

                           //askForPermission("ast");
                           showDialog("ast");

                           //Navigator.push(context, MaterialPageRoute(builder: (builder) => LoginPage("barber")));
                         },
                         child: Container(
                           padding: EdgeInsets.all(30),
                           margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                           decoration: BoxDecoration(
                             color: Colors.black,
                             borderRadius: BorderRadius.circular(10),
                           ),

                           child: Column(
                             children: [

                               Container(
                                 height: 60 ,
                                 width: 60,
                                 decoration: BoxDecoration(
                                   image: DecorationImage(
                                     image: AssetImage(
                                       "images/sbarber.png"
                                     )
                                   ),
                                 ),
                               ),

                               SizedBox(
                                 height: 20,
                               ),
                               Text(
                                 "I am Barber",
                                 textScaleFactor: 0.9,
                                 style: TextStyle(
                                   color: Color.fromRGBO(250, 250, 250, 1),
                                   fontFamily: "ubuntub",
                                   fontSize: 20
                                 ),
                               ),
                             ],
                           ),

                         ),
                       ),
                   ),

                   Expanded(
                     child: GestureDetector(
                       onTap: (){
                         showDialog("user");
                         // testData().whenComplete((){
                         //   print("data uploaded succesfully");
                         // });

                       },
                       child: Container(
                         padding: EdgeInsets.all(30),
                         margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                         decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(10),
                         ),

                         child: Column(
                           children: [

                             Container(
                               height: 60 ,
                               width: 60,
                               decoration: BoxDecoration(
                                 image: DecorationImage(
                                     image: AssetImage(
                                         "images/suser.png"
                                     )
                                 ),
                               ),
                             ),

                             SizedBox(
                               height: 20,
                             ),
                             Text(
                               "I am User",
                               textScaleFactor: 0.9,
                               style: TextStyle(
                                   color: Color.fromRGBO(250, 250, 250, 1),
                                   fontFamily: "ubuntub",
                                   fontSize: 20
                               ),
                             ),
                           ],
                         ),

                       ),
                     ),
                   ),

                 ],
               ),
             ],
           )
         ],
       )
     ),
   );
  }


  Future testData()
  async {
    await Firebase.initializeApp().then((value) {
    }).onError((error, stackTrace){
      print(error);
    });
    return await FirebaseFirestore.instance.collection("test").doc("1").set({
      'name': 'new'
    });
  }


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _message = '';

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token){
      FirebaseFirestore.instance.collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .update({'token':token.toString()});
      print(token);
    });
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a day witta properth a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {

    // if(message.data['for'] == 'orderbooked')
    // {
    //   showTopSnackBar(
    //       context,
    //       CustomSnackBar.success(
    //         message: "${message.data}",
    //         textStyle: TextStyle(
    //             fontFamily: "ubuntub",
    //             color: Colors.white,
    //             fontSize: 15
    //         ),
    //       )
    //   );
   // }


    // Navigator.push(context, MaterialPageRoute(builder: (builder) => Segrigation()));
    // // if (message.data['type'] == 'chat') {
    // //
    // //   Navigator.push(context, MaterialPageRoute(builder: (builder) => Segrigation()));
    // //   // Navigator.pushNamed(context, '/chat',
    // //   //   arguments: ChatArguments(message),
    // //   // );
    // // }

  }


  void showDialog(String user) {
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
                            width: 80,
                            height: 30,
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

                          Container(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.location_on,
                              size: 40,
                              color: getMateGold(),
                            ),
                          ),


                          Container(
                            child: Text(
                              "Use your location",
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntub",
                                fontSize: 22
                              ),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [


                                    Container(
                                      //padding: EdgeInsets.all(20),
                                      child: Image.asset("images/google_map_1.gif"),
                                      height: 120,
                                      width: 120,
                                    ),

                                    Text(
                                      "Permissions"
                                          "\n\n"
                                          "\n1. We are taking location permission to check nearby salon of user.It helps to user to easily navigate and contact."
                                          "\n2. We use the location of user only when it needs."
                                          "\n3. We used google map for search nearby salon and to show navigation."
                                          "\n3. We are taking internal storage of read and write for making gallery of vendor salon so user can see the salon images.",

                                      textAlign: TextAlign.justify,
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


                          // Row(
                          //     children: [
                          //       Container(
                          //         height: 20,
                          //         width: 20,
                          //         alignment: Alignment.centerLeft,
                          //         child: Checkbox(
                          //           value: tandc,
                          //           activeColor: getMateGold(),
                          //           onChanged: (bool? value){
                          //             setState(() {
                          //               tandc = value!;
                          //               Navigator.pop(context);
                          //             });
                          //
                          //           },
                          //         ),
                          //       ),
                          //
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //
                          //       Text(
                          //         "accept t&c",
                          //         textAlign: TextAlign.left,
                          //         textScaleFactor: 0.9,
                          //         style: TextStyle(
                          //             color: getBlackMate(),
                          //             fontFamily: "ubuntul",
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //       ),
                          //     ]
                          // )


                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: (){
                              askForPermission(user);

                          },

                          child: Text("accept"),)

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


  Future<void> askForPermission(user)
  async {

    Permission.location.request().then((status) {
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        print("Permission is denined.");
      }else if(status.isGranted){
        //permission is already granted.

        if(user == "ast")
        {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (builder) => IntroScreen()));
        }
        else{
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (builder) => LoginPage("user")));
        }
        print("Permission is already granted.");
      }else if(status.isPermanentlyDenied){
        //permission is permanently denied.
        print("Permission is permanently denied");
      }else if(status.isRestricted){
        //permission is OS restricted.
        print("Permission is OS restricted.");
      }
    });
 //   var status = await Permission.location.status;

  }
}
