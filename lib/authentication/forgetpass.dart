import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgetPass extends StatefulWidget
{
  _ForgetPass createState ()=> _ForgetPass();
}

class _ForgetPass extends State<ForgetPass>
{

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery
        .of(context)
        .textScaleFactor + 0.2;

    return SafeArea(
       child: Stack(
         children: [
           Scaffold(
             backgroundColor: Colors.white,
             appBar: AppBar(
               leading: IconButton(
                 icon: Icon(Icons.arrow_back,color: getBlackMate(),), onPressed: () {  },
               ),
               title: Text(
                 "Hair",
                 textScaleFactor: 0.9,
                 style: TextStyle(
                     color: getBlackMate(),
                     fontFamily: "ubuntur",
                     fontSize: 25

                 ),
               ),
               elevation: 0,
               backgroundColor: Colors.white,
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
             key: _scaffoldkey,
             body: Form(
               key: _formKey,
               child: SingleChildScrollView(
                 child: Column(
                   children: [
                     Container(
                       width: MediaQuery.of(context).size.width,
                       padding: EdgeInsets.fromLTRB(20, 20, 20, 0),

                       child: Text(
                           "Forget Password",

                         textScaleFactor: 0.9,
                         style: TextStyle(
                           color: getBlackMate(),
                           fontSize: 30,
                           fontFamily: "ubuntur",
                         ),
                       ),
                     ),

                     Container(
                       width: MediaQuery.of(context).size.width,
                       padding: EdgeInsets.fromLTRB(20,15, 20, 0),

                       child: Text(
                         "enter your registerd email id and then you will get link to change password.",
                         textScaleFactor: 0.9,
                         style: TextStyle(
                           color: getBlackMate(),
                           fontSize: 15,
                           fontFamily: "ubuntur",
                         ),
                       ),
                     ),


                     SizedBox(height: 20,),

                     Container(
                       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20)
                       ),
                       child: TextFormField(
                         controller: _emailPass,
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

                   ],
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
                 Container(
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
                     ),
                     child: MaterialButton(
                       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                       minWidth: MediaQuery.of(context).size.width,

                       onPressed: () async {
                         if(_formKey.currentState!.validate())
                         {
                           FirebaseAuth.instance.sendPasswordResetEmail(email: _emailPass.text.toString()).then((value){
                             showTopSnackBar(
                                 context,
                                 CustomSnackBar.success(
                                   message: "link sended",
                                   textStyle: TextStyle(
                                       fontFamily: "ubuntub",
                                       color: Colors.white,
                                       fontSize: 15/scaleFactor,
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
                                       fontSize: 15/scaleFactor
                                   ),
                                 )
                             );
                           });
                         }
                       },
                       child: Text(
                         "SEND",
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
               ],
             ),
           ) ,

         ],
       )
   );
  }


  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  double scaleFactor = 0;

  GlobalKey<FormState> _formKey = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  TextEditingController _emailPass = new TextEditingController();
}