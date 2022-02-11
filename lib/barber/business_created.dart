import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hair/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BusinessCreated extends StatefulWidget
{
  _BusinessCreated createState ()=> _BusinessCreated();
}

class _BusinessCreated extends State<BusinessCreated>
{
  @override
  Widget build(BuildContext context) {

   return SafeArea(
       child: Scaffold(
         backgroundColor: Colors.white,
         body: Stack(
           children: [
             Center(
               child: Container(
                 height: 200,
                 width: 200,

                 child: Image.asset(
                   "images/created.gif",

                   fit: BoxFit.cover,
                 ),

               ),
             ),

             Column(

               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Container(

                   margin: EdgeInsets.fromLTRB(20, 10, 20, 10),

                   width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                     color: getLightGrey(),
                     borderRadius: BorderRadius.all(Radius.circular(10)),
                   ),
                   child: MaterialButton(
                     padding: EdgeInsets.fromLTRB(10,5, 10, 5),
                     minWidth: MediaQuery.of(context).size.width,

                     onPressed: ()  {
                       Navigator.pop(context);
                     },
                     child: Text(
                       "press back to login page",
                       textScaleFactor: 0.9, style: TextStyle(
                         color: getMateGold(),
                         fontSize: 18
                     ),
                     ),
                     color: getLightGrey(),
                     elevation: 0,
                   ),
                 )
               ],
             ),


             Column(

               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(

                   margin: EdgeInsets.fromLTRB(20, 30, 20, 10),

                   width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.all(Radius.circular(10)),
                   ),
                   child: Text(
                     "Thanks for choosing Hairapp|, you will receive a confirmation from our team once it is verified and confirmed.",
                     textAlign: TextAlign.center,
                     textScaleFactor: 0.9, style: TextStyle(
                       color: getBlackMate(),
                       fontSize: 18,
                     fontFamily: "ubuntur"
                   ),
                   ),
                 )
               ],
             )

           ],
         ),
       )
   );


  }

  @override
  void initState() {
    // showTopSnackBar(
    //     context,
    //
    //     CustomSnackBar.success(
    //       message: "Thanks for choosing Hairapp! shortly, you will receive a confirmation from our"
    //           "team once it is verified and confirmed",
    //       textStyle: TextStyle(
    //           fontFamily: "ubuntub",
    //           color: Colors.white,
    //           fontSize: 15,
    //       ),
    //     ),
    //   displayDuration: Duration(milliseconds: 1000),
    //   hideOutAnimationDuration: Duration(minutes: 1),
    // );
  }

  //File _pickedImage = File("assets/images/hicon3.png");

  // Future<void> uploadAssetImage()
  // async {
  //   var data = PlatformAssetBundle().load('images/hicon3.png');
  //
  //
  //   rootBundle
  //
  //
  //   File image = File(data);
  //   // // it creates the file,
  //   // // if it already existed then just return it
  //   // // or run this if the file is created before the onTap
  //   // // if(image.existsSync()) image = await image.create();
  //   //
  //   // FirebaseStorage.instance.ref().child("userid").child("profile").putFile(image).then((snap) {
  //   //   print("done");
  //   // }).catchError((onError){
  //   //   print(onError);
  //   // });
  //
  // }
}