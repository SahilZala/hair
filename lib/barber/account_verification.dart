import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/colors.dart';

class AccountVerification extends StatefulWidget
{
  _AccountVerification createState ()=> _AccountVerification();
}

class _AccountVerification extends State<AccountVerification>
{
  Future<bool> _onWillPop() async{
   Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(body: WillPopScope(
        onWillPop: _onWillPop,
        child: Center(
          child: Text(
            "Your business is setup and awaiting approval. \n\n Contact us at xyx@gmail.com",
            textAlign: TextAlign.center,
            textScaleFactor: 0.9,
            style: TextStyle(
              color: getBlackMate(),
              fontSize: 25,
              fontFamily: "ubuntur"
            ),
          ),
    ),
      ));
  }
}