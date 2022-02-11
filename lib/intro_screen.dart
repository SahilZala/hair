import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/authentication/login.dart';
import 'package:hair/colors.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget
{
  _IntroScreen createState ()=> _IntroScreen();
}

class _IntroScreen extends State<IntroScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: IntroductionScreen(

      pages: [
        PageViewModel(
          title: 'WE PROVIDE BEST SERVICE EVER',
          body: 'We will serve you well so that you remain handsome and stylish',
          image: Image.asset("images/image1.jpg"),
          decoration: getPageDecoration(),
        ),

        PageViewModel(
          title: 'WE PROVIDE BEST SERVICE EVER',
          body: 'We will serve you well so that you remain handsome and stylish',
          image: Image.asset("images/image2.jpg"),
          decoration: getPageDecoration(),
        ),

        PageViewModel(
          title: 'WE PROVIDE BEST SERVICE EVER',
          body: 'We will serve you well so that you remain handsome and stylish',
          image: Image.asset("images/image3.jpg"),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Home', style: TextStyle(fontFamily: "ubuntur",color: getMateGold())),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip',style: TextStyle(color: getGrey(),
        fontFamily: "ubuntur",

      ),),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward,color: getGrey(),),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Colors.white,
      skipFlex: 0,
      nextFlex: 0,

    ));
  }


  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: getMateGold(),
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white,
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => LoginPage("barber")),
  );
}