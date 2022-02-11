
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hair/barber/account_verification.dart';
import 'package:hair/barber/barber_history.dart';
import 'package:hair/barber/business_type.dart';
import 'package:hair/barber/category_creation.dart';
import 'package:hair/barber/edit_package.dart';
import 'package:hair/barber/facilities.dart';
import 'package:hair/barber/gallery_update.dart';
import 'package:hair/barber/male_female.dart';
import 'package:hair/barber/orders_data.dart';
import 'package:hair/barber/package_selection.dart';
import 'package:hair/barber/time_slot_update.dart';
import 'package:hair/barber/update_business_name.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/checkout/time_date_selection.dart';
import 'package:hair/checkout/time_date_selection_new.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/create_business.dart';
import 'package:hair/firebase/services.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/handle_notification.dart';
import 'package:hair/home/user_home.dart';
import 'package:hair/barber/address_picker.dart';
import 'package:hair/barber/create_new_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;


class BarberDashboard extends StatefulWidget
{
  String userid;

  BarberDashboard(this.userid);

  _BarberDashboard createState ()=> _BarberDashboard(userid);
}

class _BarberDashboard extends State<BarberDashboard> {

  Future<bool> _onWillPop() async{
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery
        .of(context)
        .textScaleFactor + 0.2;

    _controller.addListener(() {
      print(_controller.index);

      if(_controller.index == 2)
      {
        print("notitititii");
        FirebaseFirestore.instance.collection("notification").doc(FirebaseAuth.instance.currentUser!.uid).collection("notification")

            .get()
            .then((data){

          data.docs.forEach((element) {
            print(element.data());
            FirebaseFirestore.instance.collection("notification")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("notification").doc(element.data()['nid'])
                .update({
              'visible': 'true'
            }).whenComplete(() {
              setState(() {
                _notiCount = 0;
              });
            });
          });
        });
      }
    });
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Stack(
        children: [
          SafeArea(
            child: PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.white,
              // Default is Colors.white.
              handleAndroidBackButtonPress: true,
              // Default is true.
              resizeToAvoidBottomInset: true,
              // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true,
              // Default is true.
              hideNavigationBarWhenKeyboardShows: true,
              // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style3,
              // Choose the nav bar style with this property.
            ),
          ),

          _pointer == 1 ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      getHomeWidget(),
      getServiceWidget(),
      getNotificationWidget(),
      getProfileSection(),
    ];
  }



  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.calendar_today),
        title: ("home"),
        activeColorPrimary: getBlackMate(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_dash),
        title: ("service"),
        activeColorPrimary: getBlackMate(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          children: <Widget>[
            new Icon(CupertinoIcons.bell),
            new Positioned(
              right: 0,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: new Text(
                  "$_notiCount",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),//Icon(CupertinoIcons.bell),
        title: ("bell"),
        activeColorPrimary: getBlackMate(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("profile"),
        activeColorPrimary: getBlackMate(),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }


  Widget getHomeWidget() {
    DateTime selectedDate = DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day);
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: StatefulBuilder(
        builder: (BuildContext context,
            void Function(void Function()) setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Calendar(
                  startOnMonday: true,
                  weekDays: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'So'],
                  events: _events,
                  isExpandable: false,
                  eventDoneColor: Colors.green,
                  selectedColor: getMateGold(),
                  todayColor: getBlackMate(),
                  // dayBuilder: (BuildContext context, DateTime day) {
                  //   return new Text("!");
                  // },

                  onDateSelected: (dateTime) {
                    setState(() {
                      selectedDate = DateTime(dateTime.year, dateTime.month,
                          dateTime.day);
                    });
                  },
                  locale: "en_IN",
                  eventListBuilder: (BuildContext context,
                      List<NeatCleanCalendarEvent> _selectesdEvents) {
                    print(_selectesdEvents.length);


                    return Column(
                        children: _events[selectedDate] != null
                            ? _events[selectedDate]!.map((e) {
                          print("knk  ");
                          return getAppointmentView(e);
                        }).toList()
                            : []
                    );
                  },
                  eventColor: Colors.pinkAccent,
                  todayButtonText: 'Barber',
                  expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                  dayOfWeekStyle: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 11/getScaleFactor(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getProfileSection() {
    return Scaffold(
        key: _scaffold_key,
      backgroundColor: Colors.white,
      appBar: AppBar(
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

      body: StatefulBuilder(
        builder: (BuildContext context1,
            void Function(void Function()) setState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: () {
                        _showPickOptionsDialog(0);
                      },
                      child: CircleAvatar(
                        radius: 85,
                        backgroundImage: NetworkImage(
                          userData['profile'] != null
                              ? userData['profile']
                              : "",
                        ),


                      ),
                    ),


                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(userData['firstname'], textScaleFactor: 0.9, style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,

                  ),)
                  ,
                ),
                SizedBox(
                  height: 50,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.location_on,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text("  Address",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddressPicker(userid,"business")));
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.card_membership_rounded,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text("  Business Name",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BusinessName(userid)
                              ),
                            );
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.note_add_rounded,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text("  Service category",

                          textScaleFactor: 0.9,
                          style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BusinessType(userid)
                              ),
                            );
                          },

                        ),

                      ),
                    ),
                  ],
                ),

                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.wifi,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Facilities", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Facility(userid)
                              ),
                            );
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.inventory,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Male female", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MaleFemale(userid)));
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.analytics_outlined,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Update time slots", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TimeSlotUpdate(userid)));
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.image,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" gallery", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GalleryUpdate(userid)));
                          },

                        ),

                      ),
                    ),
                  ],
                ),

                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.history,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" History", textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        History()));
                          },

                        ),

                      ),
                    ),
                  ],
                ),

                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),



                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,

                  child: Text(
                    "NEED HELP ?",
                    textScaleFactor: 0.9,
style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 20 / scaleFactor,
                    ),
                  ),
                ),


                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.support_agent_rounded,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Contact Support", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            /* Your code */
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.help_center,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Terms and condition", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            getTermsAndCondition();
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.info,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" About us", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            getAboutUs();
                          },

                        ),

                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 10,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Icon(
                        Icons.star,
                        color: getBlackMate(),
                        size: 24.0,
                        //semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(" Rate us", textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,


                        padding: const EdgeInsets.fromLTRB(165, 0, 00, 0),
                        child: IconButton(
                          icon: new Icon(Icons.keyboard_arrow_right),
                          iconSize: 30.0,

                          color: getBlackMate(),
                          //size: 24.0,

                          onPressed: () {
                            /* Your code */
                          },

                        ),

                      ),
                    ),
                  ],
                ),


                SizedBox(height: 10,),

                Container(
                  margin: EdgeInsets.all(15),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(15),
                    color: getMateGold(),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value){
                        Navigator.of(context).pop();
                        print(FirebaseAuth.instance.currentUser!.uid);
                      }).catchError((onerror){
                        print(onerror);
                      });



                    },
                    child: Text(
                        "LOGOUT",
                        textScaleFactor: 0.9,
style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntub",
                          fontSize: 20,
                        )

                    ),

                  ),
                ),


                SizedBox(height: 50,)
              ],

            ),
          );
        },
      ),
    );
  }
  
  

  Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
    DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day): [
      NeatCleanCalendarEvent('Event A',
          startTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day, 10, 0),
          endTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day, 12, 0),
          description: 'A special event',
          color: Colors.blue[700]),
    ],
    DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day + 2):
    [
      NeatCleanCalendarEvent('Event B',
          startTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day + 2, 10, 0),
          endTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day + 2, 12, 0),
          color: Colors.orange),
      NeatCleanCalendarEvent('Event C',
          startTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day + 2, 14, 30),
          endTime: DateTime(DateTime
              .now()
              .year, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day + 2, 17, 0),
          color: Colors.pink),
    ],
  };

  
  void fetchAppointments()
  {

    _events.clear();
    FirebaseFirestore.instance.collection("Orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("order")
        .where("paymentstatus",isEqualTo: "complete")
        .where("servicestatus",isEqualTo: "booked")
        .get().then((value){
          value.docs.forEach((element) {
            print("dsdsdsdsdsdsdssdsdsdsdsdsds");
            print(element.data()['selecteddate']);

            DateTime date = DateFormat("dd - MM - yyyy").parse(element.data()['selecteddate']);

            DateTime start = DateFormat("HH : mm").parse(element.data()['starttime']);
            DateTime end = start.add(Duration(minutes: int.parse(element.data()['totalduration'])));

            start = DateTime(date.year, date.month,date.day, start.hour, start.minute);
            end = DateTime(date.year, date.month,date.day, end.hour, end.minute);

            print(start);
            print(end);

            //print("lll ${date.year}");


            setState(() {

              if(_events[DateTime(
                  date.year, date.month,date.day)] == null) {


                _events[DateTime(
                    date.year, date.month,date.day)] =
                [
                  NeatCleanCalendarEvent(
                      "${element.data()['userid']}",
                      startTime: start,
                      endTime: end,
                      description: '${element.data()['orderid']}',
                      color: Colors.blue[700])];

                print("hhhh $_events");
              }
              else{
                _events[DateTime(
                    date.year, date.month,date.day)]!.add(
                    NeatCleanCalendarEvent('${element.data()['userid']}',
                        startTime: start,
                        endTime: end,
                        description: '${element.data()['orderid']}',
                        color: Colors.blue[700])
                );

              }

            });

          });
    });
  }
  
  

  int _bottomNavIndex = 0;
  PersistentTabController _controller = PersistentTabController(
      initialIndex: 0);
  String userid;



  _BarberDashboard(this.userid);

  Widget getAppointmentView(NeatCleanCalendarEvent data) {

    print("hhh  ${data.summary}");

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(data.summary).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          print(snapshot.data?.data());
          return GestureDetector(
            onTap: () async {

              // Map data1 = {
              //   "notification": {
              //     "body": "Notification from sahil",
              //     "title": "You have a new message."
              //   },
              //   "priority": "high",
              //   "data": {
              //     "clickaction": "FLUTTERNOTIFICATIONCLICK",
              //     "id": "1",
              //     "status": "done"
              //   },
              //   "to": "/topics/all"
              // };
              //
              // Map<String,String> header = {
              //   'Content-Type': 'application/json; charset=UTF-8',
              //   'Authorization' : 'key=AAAAnm8FFZs:APA91bHBwG64Fhp8p8RXubcs5xsF9ku879-mExjJUvhhOY1BDUl-QAQbCMILwY2dAFOiCpwwvyy89p9noihtdzZiNqSx8_uMFxu5WHv6lCMkeNgWvvSguSLwwTtdjwpX9i5YtRzaYs6i'
              //
              // };
              //
              //  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
              // await http.post(url, body: jsonEncode({
              //   'to': 'd6i5hE92QO2P1SQDxVGNKO:APA91bHHDq5nd2WfBZzO1kjdAJtQmyQvJR-eH_1Vc3Kk3aVOXdojRGm5c3qMA6k2uf4LSgUrFanMPvuAjMaCqQKKv27NFcnLCfWohMFY5qm6bvT-atzjbghdChzsSjwxHHoTc8s8oNSP',
              //   'data': {
              //     'via': 'FlutterFire Cloud Messaging!!!',
              //
              //   },
              //   'notification': {
              //     'title': 'Hello FlutterFire!',
              //     'body': 'This notification was created via FCM!',
              //   },
              // }),headers: header).then((value){
              //   print('Response status: ${value.statusCode}');
              //   print('Response body: ${value.body}');
              //
              // });


              //print(await http.read(Uri.parse('https://example.com/foobar.txt')));

              //sendNotifications();

             showAppointmentDialog(snapshot.data!.data(), data.description);
            },
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${data.startTime.hour}:${data.startTime.minute}",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntur",
                              fontSize: 20
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.all(2),
                          height: 2,
                          decoration: BoxDecoration(
                            color: getLightGrey1(),
                          ),
                        ),
                      ),
                    ],
                  ),


                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(

                          )
                      ),

                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Container(

                                margin: EdgeInsets.all(3),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(252, 243, 207, 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 55,
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(249, 231, 159, 1),
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Colors.white, width: 2)
                                        ),

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(snapshot.data?.data() != null ? "${snapshot.data?.data()!['firstname'][0]}" : "n",
                                                textAlign: TextAlign.center,
                                                textScaleFactor: 0.9,
style: TextStyle(
                                                    color: getGrey(),
                                                    fontSize: 25,
                                                    fontFamily: "ubuntub"
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),

                                    Expanded(
                                      flex: 7,
                                      child: Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data?.data() != null ? "${snapshot.data?.data()!['firstname']}" : "no name",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntub",
                                                    fontSize: 20

                                                ),
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),

                                                  SizedBox(width: 5,),

                                                  Text(
                                                    "${data.startTime.hour}:${data.startTime.minute} - ${data.endTime.hour}:${data.endTime.minute}",
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "ubuntur",
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 66,
                                    width: 5,
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: getBlackMate(),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))
                                    ),

                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        else{
          return Container();
        }
      },
    );


  }


  Widget getServiceWidget() {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
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

      floatingActionButton: SpeedDial(

        child: Icon(Icons.add),
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
        labelsStyle: TextStyle(color: Colors.black),
       // controller: /* Your custom animation controller goes here */,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.create_new_folder),
            foregroundColor: Colors.white,
            backgroundColor: getBlackMate(),
            label: 'Create New Package',
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PackageSelection(userid, cb.businessid)));
            },
            closeSpeedDialOnPressed: true,
          ),


          SpeedDialChild(
          closeSpeedDialOnPressed: true,
            child: Icon(Icons.padding),
            foregroundColor: Colors.white,
            backgroundColor: getBlackMate(),
            label: 'Create New Service',
            onPressed: () {
              setState(() {
                //_text = 'You pressed \"Let\'s go for a walk!\"';



                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewService(userid, cb.businessid)));
              });
            },
          ),

          SpeedDialChild(
            closeSpeedDialOnPressed: true,
            child: Icon(CupertinoIcons.list_dash),
            foregroundColor: Colors.white,
            backgroundColor: getBlackMate(),
            label: 'Create New Category',
            onPressed: () {
              setState(() {
                //_text = 'You pressed \"Let\'s go for a walk!\"';
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryCreation(userid)));
              });
            },
          ),
          //  Your other SpeeDialChildren go here.
        ],

        // onPressed: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               NewService(userid, cb.vendorid)));
        // },
        // backgroundColor: getBlackMate(),
        // shape: RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(10.0)),
        // child: Icon(
        //   Icons.add,
        //   size: 30,
        // ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [


             Container(
              padding: EdgeInsets.all(15),
              child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("services")
                            .doc(userid).collection("service")
                            //.where('homeappointment',isNotEqualTo: '${_sort == true ? false : 'kk'}')
                            .orderBy('homeappointment',descending:  _sort)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Services",
                                    textScaleFactor: 0.9,
style: TextStyle(
                                        color: getBlackMate(),
                                        fontSize: 30,
                                        fontFamily: "ubuntur"
                                    ),
                                  ) ,

                                  SizedBox(
                                    height: 20,
                                  ),


                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text(
                                            "Sort by home appointment",

                                            textScaleFactor: 0.9,
style: TextStyle(
                                              color: getBlackMate(),
                                              fontFamily: "ubuntur",
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),


                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        child: SwitcherButton(
                                          value: _sort,
                                          offColor: getBlackMate(),
                                          onColor: getMateGold(),
                                          onChange: (value) {

                                            setState((){
                                              _sort = value;
                                            });


                                          },
                                        ),
                                      ),
                                    ],
                                  ),


                                  SizedBox(
                                    height: 30,
                                  ),

                                  Column(
                                    children: snapshot.data!.docs.map((e) {

                                      Map data = e.data() as Map;
                                      return getListView(data);
                                    }).toList(),
                                  ),


                                  SizedBox(height: 10,),
                                ],
                              ),
                            );
                          }
                          else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  }),
            ),



            //package programme start

            Container(
              padding: EdgeInsets.all(15),
              child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("packages")
                            .doc(userid).collection("package").snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Packages",
                                    textScaleFactor: 0.9,
style: TextStyle(
                                        color: getBlackMate(),
                                        fontSize: 30,
                                        fontFamily: "ubuntur"
                                    ),
                                  ) ,

                                  SizedBox(
                                    height: 20,
                                  ),



                                  Column(
                                    children: snapshot.data!.docs.map((e) {

                                      Map data = e.data() as Map;
                                      return getPackageNewListView(data);
                                      }).toList(),
                                  ),


                                  SizedBox(height: 50,),
                                ],
                              ),
                            );
                          }
                          else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  }),
            ),


          ],
        ),
      ),
    );
  }


  Widget getListView(Map data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        closeOnScroll: true,
        child: Container(

          decoration: BoxDecoration(
              color: getLightGrey(),
              borderRadius: BorderRadius.circular(10)
          ),

          child: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (_) => CupertinoAlertDialog(
                title: Text("You want to?",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    fontFamily: "ubuntur",
                    fontSize: 20,
                    color: getBlackMate(),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: (){
                      Navigator.pop(context);
                      showEditDialog(data);
                    },
                    child: Text("Edit"),
                    textStyle: TextStyle(
                        fontFamily: "ubuntur",
                        color: getMateBlue()
                    ),
                  ),

                  CupertinoDialogAction(
                    onPressed: (){
                      Navigator.pop(context);
                      FirebaseFirestore.instance.collection("services").doc(userid)
                          .collection("service").doc(data['serviceid']).delete()
                          .whenComplete(() {
                        showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message: "service deleted succesfully",
                              textStyle: TextStyle(
                                  fontFamily: "ubuntub",
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            )
                        );
                      }).onError((error, stackTrace) {
                        showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "${error.toString()}",
                              textStyle: TextStyle(
                                  fontFamily: "ubuntub",
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            )
                        );
                      });
                    },
                    child: Text("Delete"),
                    textStyle: TextStyle(
                        fontFamily: "ubuntur",
                        color: getMateRed()
                    ),
                  ),
                ],
              )
              );
            },
            child: ListTile(
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['discountavailable'] == 'true' ? "₹ ${int.parse(data['price'])-int.parse(data['discount'])}" : "₹ ${int.parse(data['price'])}",
                    textScaleFactor: 0.9,
style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntub",
                      fontSize: 20
                    ),
                  ),

                  SizedBox(height: 5,),
                  Container(

                    child: data['discountavailable'] == 'true' ? Wrap(
                      children: [

                        Text(
                          "₹ ${data['price']}",
                          textScaleFactor: 0.9,
style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: "ubuntur",
                              fontSize: 15,
                            decoration: TextDecoration.lineThrough
                          ),
                        )
                      ],
                    ) : SizedBox(),
                  ),
                ],
              ) ,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: data['homeappointment'] == 'true' ? Text(
                  "H",
                  textScaleFactor: 0.9,
style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",

                  ),
                ) : Text(
                  "O",
                  textScaleFactor: 0.9,
style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",

                  ),
                ),
                  foregroundColor: getBlackMate(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    //val.service_category
                    "${data['servicecategory']}",
                    textScaleFactor: 0.9,
style: TextStyle(
                      color: getBlackMate(),
                        fontFamily: "ubuntub",
                        fontSize: 15
                    ),
                  ),

                  SizedBox(
                    height: 5,

                  ),

                  Text("${data['servicename']}",
                    textScaleFactor: 0.9,
                    style: TextStyle(color: getBlackMate(),
                      fontFamily: "ubuntur",
                    ),),


                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              subtitle: Text(
                //val.service_category
                "${data['serviceduration']} Minutes",
                textScaleFactor: 0.9,
style: TextStyle(
                    fontFamily: "ubuntur",
                    fontSize: 13
                ),
              ),
            ),
          ),
        ),

        // actions: [
        //   IconButton(onPressed: () {
        //
        //   },
        //       icon: Icon(
        //         Icons.edit,
        //         color: getMateBlue(),
        //       )
        //   )
        // ],
        // secondaryActions: <Widget>[
        //
        //
        //   IconButton(
        //       onPressed: () {
        //
        //       },
        //       icon: Icon(Icons.delete, color: getMateRed(),)
        //   ),
        //
        // ],
      ),
    );
  }


  Widget getPackageNewListView(Map data)
  {

    List services = data['service'];
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),


        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,

              trailing: IconButton(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.workspaces_filled,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: (){
                  showDialog(context: context, builder: (_) => CupertinoAlertDialog(
                    title: Text("Choose one",
                      textScaleFactor: 0.9,
style: TextStyle(
                        fontFamily: "ubuntur",
                        fontSize: 20,
                        color: getBlackMate(),

                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: (){
                          Navigator.pop(context);

                          //showPackageEditDialog(data);


                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditPackageSelection(data)));



                        },
                        child: Text("Edit"),
                        textStyle: TextStyle(
                            fontFamily: "ubuntur",
                            color: getMateBlue()
                        ),
                      ),




                      CupertinoDialogAction(
                        onPressed: (){
                          Navigator.pop(context);
                          FirebaseFirestore.instance.collection("packages").doc(userid)
                              .collection("package").doc(data['packageid']).delete()
                              .whenComplete(() {
                            showTopSnackBar(
                                context,
                                CustomSnackBar.success(
                                  message: "package deleted succesfully",
                                  textStyle: TextStyle(
                                      fontFamily: "ubuntub",
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                )
                            );
                          }).onError((error, stackTrace) {
                            showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: "${error.toString()}",
                                  textStyle: TextStyle(
                                      fontFamily: "ubuntub",
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                )
                            );
                          });
                        },
                        child: Text("Delete"),
                        textStyle: TextStyle(
                            fontFamily: "ubuntur",
                            color: getMateRed()
                        ),
                      ),
                    ],
                  )
                  );

                },
              ),
              title: Text("${data['packagename'].toString().toUpperCase()}",
                textScaleFactor: 0.9,
                style: TextStyle(color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 20
                ),),

            ),



            Column(
              children: services.map((element){
                print(element);
                return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("services")
                        .doc(userid).collection("service").where('serviceid',isEqualTo: '$element') //.orderBy('homeappointment',descending:  _sort)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: snapshot.data!.docs.map((e) {

                                Map data = e.data() as Map;
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),

                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      foregroundColor: getBlackMate(),
                                      child: Text(
                                        "${data['servicename'][0].toString().toUpperCase()}",
                                        textScaleFactor: 0.9,
style: TextStyle(
                                          color: getBlackMate(),
                                          fontFamily: "ubuntub",
                                        ),
                                      ),
                                    ),
                                    trailing: Text(
                                      "₹ ${data['price']}",
                                      textScaleFactor: 0.9,
style: TextStyle(
                                          color: getMateGold(),
                                          fontFamily: "ubuntub",
                                          fontSize: 20
                                      ),
                                    ) ,

                                    title: Text("${data['servicename'].toString().toUpperCase()}",
                                      textScaleFactor: 0.9,
                                      style: TextStyle(color: getBlackMate(),
                                        fontFamily: "ubuntur",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15
                                      ),),
                                    subtitle: Text(
                                      "${data['serviceduration']} Minutes",
                                      textScaleFactor: 0.9,
style: TextStyle(
                                          fontFamily: "ubuntur",
                                          fontSize: 13
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ],
                        );
                      }
                      else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              }).toList(),
            )


          ],
        ),

      ),
    );
  }


  Widget getPackageListView(Map data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        closeOnScroll: true,
        child: Container(

          decoration: BoxDecoration(
              color: getLightGrey(),
              borderRadius: BorderRadius.circular(10)
          ),

          child: GestureDetector(
            onTap: (){
              
              showDialog(context: context, builder: (_) => CupertinoAlertDialog(
                title: Text("Choose one",
                  textScaleFactor: 0.9,
style: TextStyle(
                    fontFamily: "ubuntur",
                    fontSize: 20,
                    color: getBlackMate(),

                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: (){
                      Navigator.pop(context);

                      //showPackageEditDialog(data);


                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditPackageSelection(data)));



                    },
                    child: Text("Edit"),
                    textStyle: TextStyle(
                      fontFamily: "ubuntur",
                      color: getMateBlue()
                    ),
                  ),

                  CupertinoDialogAction(
                    onPressed: (){
                      Navigator.pop(context);
                      FirebaseFirestore.instance.collection("packages").doc(userid)
                          .collection("package").doc(data['packageid']).delete()
                          .whenComplete(() {
                        showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message: "package deleted succesfully",
                              textStyle: TextStyle(
                                  fontFamily: "ubuntub",
                                  color: Colors.white,
                                  fontSize: 15/getScaleFactor(context)
                              ),
                            )
                        );
                      }).onError((error, stackTrace) {
                        showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "${error.toString()}",
                              textStyle: TextStyle(
                                  fontFamily: "ubuntub",
                                  color: Colors.white,
                                  fontSize: 15/getScaleFactor(context)
                              ),
                            )
                        );
                      });
                    },
                    child: Text("Delete"),
                    textStyle: TextStyle(
                        fontFamily: "ubuntur",
                        color: getMateRed()
                    ),
                  ),
                ],
              )
              );

            },
            child: ListTile(
              trailing: Text(
                "₹ ${data['price']}",
                textScaleFactor: 0.9,
style: TextStyle(
                    color: getMateGold(),
                    fontFamily: "ubuntub",
                    fontSize: 20
                ),
              ) ,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: getBlackMate(),
                child: Text(
                  "${data['packagename'][0].toString().toUpperCase()}",
                  textScaleFactor: 0.9,
style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                  ),
                ),
              ),
              title: Text("${data['packagename']}",
                textScaleFactor: 0.9,
                style: TextStyle(color: getBlackMate(),
                  fontFamily: "ubuntur",
                ),),
              subtitle: Text(
                //val.service_category
                "${data['duration']} Minutes",
                textScaleFactor: 0.9,
style: TextStyle(
                    fontFamily: "ubuntur",
                    fontSize: 13
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }






  void showEditDialog(Map data) {

    print(spinnerItems);

    _service_name.text = data['servicename'];
    _service_description.text = data['servicedescription'];
    _price.text = data['price'];
    _discount.text = data['discount'];
    duartionValue = data['serviceduration'];
    pricingValue = data['pricingtype'];
    categoryValue = data['servicecategory'];
    dropdownValue = data['servicetype'];

    genderSelection = data['servicegender'];
    data['onlinebooking'] == "true" ? _online_booking =  true : _online_booking =  false;
    data['discountavailable'] == "true" ? _discount_on = true : _discount_on = false;
    data['homeappointment'] == "true" ? _home_appointment = true : _home_appointment = false;
    data['seattype'] == "treatment" ? _seat_distribution = 0 : _seat_distribution = 1;


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
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                setState((){



                });
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.remove,
                            color: getBlackMate(),
                            size: 30,
                          ),
                        ),
                        elevation: 0,
                      ),
                      body: SafeArea(
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(

                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                getTitle(),
                                getFormWidget(context, setState, data)
                              ],
                            ),
                          ),
                        ),
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




  Widget getTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(
        "Add a new service",
        textScaleFactor: 0.9,
style: TextStyle(
            color: getBlackMate(),
            fontFamily: "ubuntub",
            fontSize: 25

        ),
      ),
    );
  }

  int _seat_distribution = 0;

  Widget getFormWidget(BuildContext context, setState, Map data) {

    return StatefulBuilder(
        builder: (BuildContext context,
            void Function(void Function()) setStateService) {
          return Form(
              key: _service_form_update,
              child: SingleChildScrollView(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: getLightGrey(), width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: getLightGrey()
                      ),
                      child: DropdownButton<String>(
                        value: categoryValue,
                        icon: Expanded(child: Container(
                          child: Icon(Icons.arrow_drop_down,),
                          alignment: Alignment.centerRight,)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                        underline: Container(
                          height: 2,
                          color: getLightGrey(),
                        ),
                        onChanged: (val) {
                          setStateService(() {
                            categoryValue = val!;
                          });
                        },
                        items: categorySpinnerItems.map<
                            DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: getLightGrey(), width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: getLightGrey()
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Expanded(child: Container(
                          child: Icon(Icons.arrow_drop_down,),
                          alignment: Alignment.centerRight,)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                        underline: Container(
                          height: 2,
                          color: getLightGrey(),
                        ),
                        onChanged: (val) {
                          setStateService(() {
                            dropdownValue = val!;
                          });
                        },
                        items: spinnerItems.map<
                            DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _service_name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter service title';
                          }
                          return null;
                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20 / scaleFactor
                        ),

                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "service title",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate())
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Container(

                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _service_description,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter description of service';
                          }
                          return null;
                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20 / scaleFactor
                        ),

                        minLines: 2,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "service description",

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate())
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: getLightGrey(),width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: getLightGrey()
                      ),
                      child: DropdownButton<String>(
                        value: genderSelection,
                        icon: Expanded(child: Container(
                          child: Icon(Icons.arrow_drop_down,),
                          alignment: Alignment.centerRight,)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                        underline: Container(
                          height: 2,
                          color: getLightGrey(),
                        ),
                        onChanged: (val) {
                          setState(() {
                            genderSelection = val!;
                          });
                        },
                        items: genderSpinner.map<
                            DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20,),


                    // Container(
                    //   height: 20,
                    //   color: getLightGrey(),
                    //   width: MediaQuery
                    //       .of(context)
                    //       .size
                    //       .width,
                    // ),
                    //
                    // SizedBox(height: 20,),
                    //
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Online booking",
                    //         style: TextStyle(
                    //           color: getBlackMate(),
                    //           fontFamily: "ubuntub",
                    //           fontSize: 20,
                    //         ),
                    //       ),
                    //
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //
                    //       Text(
                    //         "Enable online bookings choose who the service is available for and add a short description",
                    //         textAlign: TextAlign.justify,
                    //         textScaleFactor: 0.9,
                    //         style: TextStyle(
                    //             color: getGrey(),
                    //             fontFamily: "ubuntur",
                    //             fontSize: 14
                    //         ),
                    //
                    //       )
                    //     ],
                    //   ),
                    // ),
                    //
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    //       child: SwitcherButton(
                    //         value: _online_booking,
                    //         offColor: getBlackMate(),
                    //         onColor: getMateGold(),
                    //         onChange: (value) {
                    //           _online_booking = value;
                    //           print(_online_booking);
                    //           // setState((){
                    //           //   _online_booking = value;
                    //           // });
                    //         },
                    //       ),
                    //     ),
                    //
                    //     Text(
                    //       "Enable online bookings",
                    //       style: TextStyle(
                    //         color: getBlackMate(),
                    //         fontFamily: "ubuntur",
                    //         fontSize: 15,
                    //
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      height: 20,
                      color: getLightGrey(),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pricing and Duration",
                            style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 20,
                            ),

                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Add the pricing options and duration of the service.",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: getGrey(),
                                fontSize: 14,
                                fontFamily: "ubuntur"
                            ),
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 7.5, 0),
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: getLightGrey(), width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: getLightGrey()
                                  ),
                                  child: DropdownButton<String>(
                                    value: duartionValue,
                                    icon: Expanded(child: Container(
                                      child: Icon(Icons.arrow_drop_down,),
                                      alignment: Alignment.centerRight,)),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: getBlackMate(), fontSize: 18),
                                    underline: Container(
                                      height: 2,
                                      color: getLightGrey(),
                                    ),
                                    onChanged: (val) {
                                      setStateService(() {
                                        duartionValue = val!;
                                      });
                                    },
                                    items: duartionValueSpinnerItems.map<
                                        DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: value == 'duration' ? Text(
                                            "$value") : Text("$value Minutes"),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                              // Expanded(
                              //   child: Container(
                              //     margin: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                              //     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //             color: getLightGrey(), width: 2),
                              //         borderRadius: BorderRadius.circular(10),
                              //         color: getLightGrey()
                              //     ),
                              //     child: DropdownButton<String>(
                              //       value: pricingValue,
                              //       icon: Expanded(child: Container(
                              //         child: Icon(Icons.arrow_drop_down,),
                              //         alignment: Alignment.centerRight,)),
                              //       iconSize: 24,
                              //       elevation: 16,
                              //       style: TextStyle(
                              //           color: getBlackMate(), fontSize: 18),
                              //       underline: Container(
                              //         height: 2,
                              //         color: getLightGrey(),
                              //       ),
                              //       onChanged: (val) {
                              //         setStateService(() {
                              //           pricingValue = val!;
                              //         });
                              //       },
                              //       items: pricingCalueSpinner.map<
                              //           DropdownMenuItem<String>>((
                              //           String value) {
                              //         return DropdownMenuItem<String>(
                              //           value: value,
                              //           child: Text(value),
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),

                          SizedBox(height: 20,),

                          Container(

                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: TextFormField(
                              controller: _price,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter price';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontSize: 20 / scaleFactor
                              ),

                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              decoration: InputDecoration(
                                hintText: "price",
                                prefixIcon: Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: Text("₹",
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                        color: getBlackMate(),
                                        fontFamily: "ubuntur",
                                        fontSize: 22
                                    ),
                                  ),
                                ),

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: getBlackMate()),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 2, color: getBlackMate())
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),


                    Container(
                      height: 20,
                      color: getLightGrey(),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discount",
                            textScaleFactor: 0.9,
style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 20,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Enable discount service choose to give different advantages to your clients.",
                            textAlign: TextAlign.justify,
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: getGrey(),
                                fontFamily: "ubuntur",
                                fontSize: 14
                            ),

                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: SwitcherButton(
                            value: _discount_on,
                            offColor: getBlackMate(),
                            onColor: getMateGold(),
                            onChange: (value) {
                              setStateService((){
                                _discount_on = value;
                              });
                            },
                          ),
                        ),

                        Text(
                          "Enable discount service",
                          textScaleFactor: 0.9,
style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 15,

                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    _discount_on == true ? Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _discount,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter discount percentage';
                          }
                          return null;
                        },
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20 / scaleFactor
                        ),

                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: "discount in amount",
                          prefixIcon: Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            child: Text("₹",
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                  fontSize: 22
                              ),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate()),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: getBlackMate())
                          ),
                        ),
                      ),
                    ) : Container(),

                    SizedBox(height: 20,),


                    Container(
                      height: 20,
                      color: getLightGrey(),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Home Service",
                            textScaleFactor: 0.9,
style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 20,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Enable home service to give service to your client at home.",
                            textAlign: TextAlign.justify,
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: getGrey(),
                                fontFamily: "ubuntur",
                                fontSize: 14
                            ),

                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: SwitcherButton(
                            value: _home_appointment,
                            offColor: getBlackMate(),
                            onColor: getMateGold(),
                            onChange: (value) {
                              _home_appointment = value;
                            },
                          ),
                        ),

                        Text(
                          "Enable home service",
                          textScaleFactor: 0.9,
style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 15,

                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),


                    Container(
                      height: 20,
                      color: getLightGrey(),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select seat type",
                            textScaleFactor: 0.9,
style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 20,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Select seat type from given.",
                            textAlign: TextAlign.justify,
                            textScaleFactor: 0.9,
                            style: TextStyle(
                                color: getGrey(),
                                fontFamily: "ubuntur",
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setStateService(() {
                              _seat_distribution = 1;
                              // print("s");
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: _seat_distribution == 0 ? 1 : 10,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3 - 50,
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _seat_distribution == 0 ? Colors
                                      .transparent : getMateGold(),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "images/chair.png",
                                              ),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ),

                                    SizedBox(height: 8,),

                                    Text(
                                      "salon seat",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: getBlackMate(),
                                          fontSize: 14,
                                          fontFamily: "ubuntur"
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: _seat_distribution == 0 ? 10 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setStateService(() {
                                  _seat_distribution = 0;
                                });
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3 - 30,
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _seat_distribution == 0
                                      ? getMateGold()
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "images/treatment_chair.png",
                                              ),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ),

                                    SizedBox(height: 8,),

                                    Text(
                                      "treatment seat",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: getBlackMate(),
                                          fontSize: 14,
                                          fontFamily: "ubuntur"
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),


                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Container(

                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),

                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          color: getBlackMate(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery
                              .of(context)
                              .size
                              .width,

                          onPressed: () async {
                            if (_service_form_update.currentState!.validate()) {

                              if(_discount_on == true && (int.parse(_discount.text) > 0 && int.parse(_discount.text) < int.parse(_price.text)))
                              {
                                Services servicedata = new Services.create(
                                    _service_name.text,
                                    dropdownValue,
                                    _service_description.text,
                                    categoryValue,
                                    genderSelection,
                                    _online_booking.toString(),
                                    duartionValue,
                                    pricingValue,
                                    _price.text,
                                    _discount_on.toString(),
                                    _discount.text,
                                    _home_appointment.toString(),
                                    _seat_distribution == 1
                                        ? "salon"
                                        : "treatment");


                                CreateBusiness cb = new CreateBusiness.service(
                                    data['vendorid'], data['businessid'], "time",
                                    "date");

                                cb.updateService(servicedata, data['serviceid'])
                                    .whenComplete(() {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.success(
                                        message: "Service updated succesfully",
                                        textStyle: TextStyle(
                                            fontFamily: "ubuntub",
                                            color: Colors.white,
                                            fontSize: 15
                                        ),
                                      )
                                  );
                                  Navigator.pop(context);
                                }).catchError((error) {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "${error.toString()}",
                                        textStyle: TextStyle(
                                            fontFamily: "ubuntub",
                                            color: Colors.white,
                                            fontSize: 15
                                        ),
                                      )
                                  );
                                });

                                setState(() {
                                  // _services.add(data);
                                  // //   dispose();
                                  // Navigator.pop(context);
                                });


                                _service_name.text = "";
                                _service_description.text = "";
                                _price.text = "";
                                _discount.text = "";
                              }
                              else{
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: "Please enter proper discount value",
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    )
                                );
                              }

                            }
                          },
                          child: Text(
                            "UPDATE",
                            textScaleFactor: 0.9, style: TextStyle(
                              color: getMateGold(),
                              fontSize: 18 / scaleFactor
                          ),
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        ),
                      ),
                    ),

                    //SizedBox(height: 100,),
                  ],
                ),
              )
          );
        }
    );
  }



  Future<DocumentSnapshot<Map>> fetchUserdata() async =>
      await FirebaseFirestore.instance.collection("users").doc(userid).get();

  CreateBusiness cb = new CreateBusiness.fetch();

  Map userData = new Map();

  int _pointer = 0;

  _loadPicker(ImageSource source, int comes) async {
    PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
    if (picked != null) {

      setState(() {
        _pointer = 1;
      });


      CreateBusiness cb = new CreateBusiness.fetch();
      cb.uploadProfileImage(File(picked.path), userid).then((value){
        value.ref.getDownloadURL().then((value){
          FirebaseFirestore.instance
              .collection("users")
              .doc(userid)
              .update({"profile": value.toString()}).whenComplete((){

            setState(() {
              fetchUserdata().then((value) {
                userData = value.data()!;
              });
              _pointer = 0;
            });
          });

        });
      });
    }
    // Navigator.pop(context);
  }


  void _showPickOptionsDialog(int comesFrom) {

    _scaffold_key.currentState!.showBottomSheet((context){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        color: getLightGrey(),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      _loadPicker(ImageSource.gallery,comesFrom);
                      Navigator.pop(context);
                    },
                    child: Text(
                        "gallery",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20
                        )
                    ),
                  )
              ),

              comesFrom == 0 ? Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      _loadPicker(ImageSource.camera,comesFrom);
                      Navigator.pop(context);
                    },
                    child: Text(
                        "camera",
                        textScaleFactor: 0.9,
style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20
                        )
                    ),
                  )
              ) : SizedBox(),

              SizedBox(
                height: 50,
              )
            ],
          ),
        ),

      );
    });

    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (_) =>
    //       CupertinoActionSheet(
    //         actions: [
    //           CupertinoActionSheetAction(
    //               onPressed: () {
    //                 _loadPicker(ImageSource.gallery, comesFrom);
    //
    //                 Navigator.pop(context);
    //               },
    //               child: Text("gallery")
    //           ),
    //           CupertinoActionSheetAction(
    //               onPressed: () {
    //                 _loadPicker(ImageSource.camera, comesFrom);
    //                 Navigator.pop(context);
    //               },
    //               child: Text("camera")
    //           ),
    //
    //         ],
    //
    //         cancelButton: CupertinoActionSheetAction(
    //           child: Text("cancel"),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //       ),
    // );
  }

  void showAppointmentDialog(Map? clientdata,String orderid) {
    
    
    
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        
        return FutureBuilder(
          future: FirebaseFirestore
              .instance
              .collection("Orders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("order").doc(orderid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot)
            {
              if(snapshot.hasData)
              {
                if(snapshot.data!.data() != null)
                {

                  Map ?orderdata =  snapshot.data!.data();

                  print("sahilsahil ${orderdata}");
                  List serviceData = snapshot.data?.data()!['serviceid'];

                  List serviceid = orderdata!['serviceid'];
                  List<String> serviceidList = [];
                  serviceid.forEach((element) {
                    serviceidList.add(element);
                  });


                  Map slotMapData = orderdata['slots'];

                  SplayTreeMap<String,NewSlots> slotMap = new SplayTreeMap();



                  slotMapData.forEach((key, value) {
                    print("$key = $value");

                    slotMap["$key"] = NewSlots(value['start'], int.parse(value['status']));

                  });


                  print("sasass ${orderdata['total']}");


                  OrderClass oc = new OrderClass(
                     orderdata['userid'],
                      orderdata['vendorid'],
                      serviceidList,
                      orderdata['seattype'],
                      orderdata['selecteddate'],
                      orderdata['seatnumber'],
                      orderdata['gender'],
                      orderdata['starttime'],
                      orderdata['endtime'],
                      orderdata['servicestatus'],
                      orderdata['totalduration'],
                      orderdata['slotcount'],
                      slotMap,
                      orderdata['lat'],
                      orderdata['log'],
                      orderdata['address']
                  );



                  oc.disount = snapshot.data!.data()!['discount'];
                  oc.finaltotal = snapshot.data!.data()!['finaltotal'];
                  oc.total = snapshot.data!.data()!['total'];
                  oc.tax = snapshot.data!.data()!['tax'];
                  oc.orderid = snapshot.data!.data()!['orderid'];
                  oc.serviceplace = snapshot.data!.data()!['serviceplace'];

                  orderdata['servicetype'] == null ?
                  oc.servicetype = "service" : orderdata['servicetype'] == "service" ?
                  oc.servicetype = "service" : oc.servicetype = "package";


                  print("oooo ${snapshot.data?.data()}");
                  return Align(
                      alignment: Alignment.bottomCenter,
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return SafeArea(
                            child: Container(
                              width: MediaQuery.of(context).size.width,

                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Scaffold(
                                backgroundColor: Colors.white,
                                body: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                  Icons.minimize,
                                                color: getBlackMate(),
                                                size: 30,
                                              )
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),

                                          Text(
                                              "${clientdata!['firstname']}",
                                            textScaleFactor: 0.9,
                                            style: TextStyle(
                                              color: getBlackMate(),
                                              fontSize: 30,
                                              fontFamily: "ubuntub"
                                            ),
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Text(
                                            "address in descriptive formate",
                                            textScaleFactor: 0.9,
                                            style: TextStyle(
                                                color: getGrey(),
                                                fontSize: 15,
                                                fontFamily: "ubuntur"
                                            ),
                                          ),

                                          SizedBox(
                                            height: 50,
                                          ),

                                          Text(
                                            "Date & Time",
                                            textScaleFactor: 0.9,
                                              style: TextStyle(
                                              color: getBlackMate(),
                                              fontFamily: "ubuntur",
                                              fontSize: 25
                                            )
                                          ),

                                          SizedBox(
                                            height: 15,
                                          ),


                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "date : ",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                    color: getGrey(),
                                                    fontSize: 18
                                                  ),

                                                ),
                                              ),

                                              Expanded(
                                                child: Text(
                                                  "${snapshot.data?.data()!['selecteddate']}",
                                                  textAlign: TextAlign.right,
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                      color: getGrey(),
                                                      fontSize: 18
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "time : ",
                                                  textScaleFactor: 0.9,
style: TextStyle(
                                                      color: getGrey(),
                                                      fontSize: 18
                                                  ),

                                                ),
                                              ),

                                              Expanded(
                                                child: Text(

                                                  "${DateFormat("HH : mm").parse(snapshot.data?.data()!['starttime']).hour} : "
                                                      "${DateFormat("HH : mm").parse(snapshot.data?.data()!['starttime']).minute == 0 ? "00" : DateFormat("HH : mm").parse(snapshot.data?.data()!['starttime']).minute}",

                                                  textAlign: TextAlign.right,
                                                  textScaleFactor: 0.9,
style: TextStyle(
                                                      color: getGrey(),
                                                      fontSize: 18
                                                  ),

                                                ),
                                              )
                                            ],
                                          ),


                                          SizedBox(
                                            height: 20,
                                          ),

                                         Text(
                                              "Services",
                                              textScaleFactor: 0.9,
style: TextStyle(
                                                  color: getBlackMate(),
                                                  fontFamily: "ubuntur",
                                                  fontSize: 25
                                              )
                                          ),

                                          SizedBox(
                                            height: 15,
                                          ),


                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "service",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                      color: getBlackMate(),
                                                      fontSize: 20
                                                  ),

                                                ),
                                              ),

                                              Expanded(
                                                child: Text(

                                                  "servcie type",
                                                  textScaleFactor: 0.9,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: getBlackMate(),
                                                      fontSize: 20
                                                  ),

                                                ),
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 15,
                                          ),




                                          Column(
                                            children: serviceData.map((e) {
                                              return FutureBuilder(
                                                future: FirebaseFirestore.instance
                                                    .collection("services")
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection("service").doc(e).get(),
                                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                  if(snapshot.hasData)
                                                  {
                                                    if(snapshot.data?.data() != null)
                                                    {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "${snapshot.data?.data()!['servicename']}",
                                                                  textScaleFactor: 0.9,
                                                                  style: TextStyle(
                                                                      color: getGrey(),
                                                                      fontSize: 18
                                                                  ),

                                                                ),
                                                              ),

                                                              Expanded(
                                                                child: Text(

                                                                  "${snapshot.data?.data()!['servicecategory']}",
                                                                  textScaleFactor: 0.9,
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(
                                                                      color: getGrey(),
                                                                      fontSize: 18
                                                                  ),

                                                                ),
                                                              )
                                                            ],
                                                          ),



                                                          SizedBox(
                                                            height: 10,
                                                          )


                                                        ],
                                                      );
                                                    }
                                                    else{
                                                      return Container();
                                                    }
                                                  }
                                                  else{
                                                    return Container();
                                                  }
                                                },
                                              );
                                            }).toList(),
                                          ),

                                          SizedBox(height: 20,),


                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Seat number",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                      color: getBlackMate(),
                                                      fontSize: 25
                                                  ),

                                                ),
                                              ),

                                              Expanded(
                                                child: Text(

                                                  "${oc.seatnumber}",
                                                  textScaleFactor: 0.9,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: getGrey(),
                                                      fontSize: 25
                                                  ),

                                                ),
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),


                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Place",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                      color: getBlackMate(),
                                                      fontSize: 25
                                                  ),

                                                ),
                                              ),

                                              Expanded(
                                                child: Text(

                                                  "${oc.serviceplace}",
                                                  textScaleFactor: 0.9,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: getGrey(),
                                                      fontSize: 20
                                                  ),

                                                ),
                                              )
                                            ],
                                          ),






                                          SizedBox(
                                            height: 50,
                                          )

                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(

                                                decoration: BoxDecoration(

                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () {


                                                    print(snapshot);

                                                    Navigator.pop(context);

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OrdersData(oc)));
                                                  },

                                                  child: Text(
                                                    "view",
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "ubutnur",
                                                      fontSize: 20
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ),


                                            SizedBox(
                                              width: 20,
                                            ),

                                            Expanded(
                                              child: Container(

                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () async {

                                                    cancelBooking(oc,context);
                                                  },

                                                  child: Text(
                                                    "cancel",
                                                    textScaleFactor: 0.9,
style: TextStyle(
                                                        color: Colors.white,

                                                        fontFamily: "ubutnur",
                                                        fontSize: 20
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ),
                          );
                        },
                      )
                  );
                }
                else{
                  return Container();
                }
              }
              else{
                return Container();
              }
            }
          );


      },
    );
  }


  void getAboutUs()
  {
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
                            width: 100,
                            height: 50,

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
                                color: getLightGrey(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      "Hair is an online destination for salons and their clients. It's an online booking appointment app. It is a pool for both salons and customers. Professionals can show case their work, connect with existing clients and build their business.Clients can discover new services and providers, book appointments online, and get inspired.",
                                      textAlign: TextAlign.justify,
                                      textScaleFactor: 0.9,
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


  void getTermsAndCondition()
  {
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
                            width: 100,
                            height: 50,

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
                                color: getLightGrey(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      " HAIR TERMS AND CONDITIONS"
                                          "Acceptance of terms Updated on 25-06-2020"
                                          "Please read all the terms and conditions before registering on or accessing HAIR mobile application. By using HAIR Mobile App ,"
                                          "You are bound to accept all the terms and conditions provided by the HAIR Mobile App."
                                          "These terms and conditions applicable on all HAIR Services present inside app the terms and conditions may vary  from time to time ."
                                          " Hence you are requested to refer changes in terms and conditions from time to time on notice of change given to them. "
                                          "Your continued use of the app will mean you accept and agree to such amendment. Through this application you can book slot for the services provided by HAIR. "
                                          "The user acknowledges and agrees that the user has complete responsibility while ordering services through the HAIR mobile app."
                                          "For using HAIR mobile app Terms of service are made to make you aware of your legal obligation with respect your access and usage of HAIR mobile app."
                                          "Profile management You shall be responsible for maintaining your user name and password. Use of app for more than one user is prohibited. "
                                          "You agree that any information provided is false,inaccurate or incomplete HAIR have the right to suspend, "
                                          "terminate or block your account from Hair mobile app.Don’t share your OTP (one time password) with anybody else .Once you signed up account will be permanent."
                                          "\n\n\n"
                                          "Eligibility to use You must be at least eighteen (18) years of age or above and capable of entering, performing to these terms. "
                                          "This app is available only to those who are binding to form a valid legal contract under Indian contract Act, 1872. "
                                          "If the user is minor then he /she can use this application only with supervision and guidance of their parents. "
                                          "\n\n\n"
                                          "Appointment and booking"
                                          "\n"
                                          "The user can make a request for booking a slot at the salon by confirming via the HAIR application will be confirmed by to the"
                                          "user short message service (SMS)or by any other means of communication only after the salon accepts and confirms the booking."
                                          "For booking you need to provide accurate time and date."
                                          "Deals once confirmed cannot be exchanged or returned. Once the booking has done through the app customer can or cannot cancel it ."
                                          "*Need to report the desired HAIR 10 minutes  in advance of the scheduled booking time,otherwise delay may occur. We are not responsible for such delay .HAIR will not entertain any time barred appointment."
                                          "\nHAIR shall have the right to block any member if caused more than 2 cancellations without taking any service."
                                          "\nHAIR app meant for slot booking not any service based issues."
                                          "\nThe user understands that some type of services may be suitable for users within certain age ranges and gender only unless mentioned otherwise."
                                          "\nIt is the users sole responsibility to check whether the services ordered are suitable for the intended recipient."
                                          "\nHAIR is not liable for any loss or damage of any personal belonging and reaction to skin or hair."
                                          "\nHAIR shall have the right to deny bookings if the slot is unavailable or any other reasons like festive season ."
                                          "\nHAIR shall have the right to cancel  all booking slots without any prior notification ."
                                          "\nHAIR shall have the right to deny any additional service requested rather than the app booked service."
                                          "\nAll the images used in the HAIR app are only for illustrative purpose."
                                          "\nCustomer do not have the choice of a particular Stylist/Beautician,If he or she on other assignment."
                                          "\nMembership Customer offers can not be appicable for slot booking."
                                          "\nIf the particular offer price is same or above the app booking amount then customer can book it."
                                          "\n\n Prices and payment"
                                          "\n\n All prices shown in the app may vary different cities. We recommend you to select different HAIR before making an appointment."
                                          "Prices may vary after inclusion of GST (Goods service tax) .While HAIR takes great care to keep them up to date, the final price charged to you by Hair"
                                          "salons listed may change at the time of delivery based on the latest menu and prices.HAIR reserves the right to alter the menu of the services available"
                                          "for usage on the HAIR mobile app and or the website and to delete and remove them if needed."
                                          "No online payment provided. Only counter payment."
                                          "We don’t send email bills. All credit cards, debitcards are accepted. No booking charges. "
                                          "For a combo service or any other service either you completed or not you need to pay the whole amount as promised through HAIR application &The same is applicable for CHOICE COMBOS as well."
                                          "If additional services perceive from the salon directly you need to pay the amount of relatedservice separately. We do accept only INR (Indian Rupees). "
                                          "Offers/packages need to be redeemed within stipulate duration of time or they holdexpire by default."
                                          "\nHAIR Shall have the right to withdraw the offers and advertisements displays in the HAIR mobile application without any prior notification."
                                          "For Membership Customer offers will not be conjucture with app offer."
                                          "\n\n\n Review \n\n"
                                          "You shall not comment any wordings which shall not be defamatory abusive obscene offensive sexually offensive threatening harassing racially"
                                          "offensive or illegal material, affect the feelings of other users or badly affect integrity of society."
                                          "We strictly prohibit transmitting any political content."
                                          "\n\n Outdoor service \n\n "
                                          "We do have outdoor services for Bride and Groom make up, Hairdo, saree draping etc.  . Our specialist arrives at your place through their vehicle."
                                          "Customer need not provide any transportation."
                                          "\n"
                                          "Its customer’s duty to provide an eco-friendly platform for our specialist any kind of interference due to behavior of any of the person"
                                          "from you the app holder will be liable for that .HAIR is not liable for any delay caused in arrival of specialist due to traffic or"
                                          "any unpredictable happenings. In the event you have provided incorrect contact number or address or you are unresponsive or unavailable"
                                          "for fulfillment service offered to you HAIR is not liable."
                                          "\n"
                                          "Incalculable events"
                                          "\n"
                                          "Any unforeseeable event like Hartal, Natural calamities etc. the booking will be automatically cancelled. App holder need to book for another day."
                                          "Booking priority will not apply."
                                          "\n"
                                          "Communication"
                                          "\n"
                                          "When you use of HAIR mobile application, you agree that you are communicating with HAIR through electronic records and you consent receive"
                                          "communications via electronic records from HAIR periodically and as and when required."
                                          "HAIR may communicate with you through SMS or other electronic methods."
                                          "\n"
                                          "Restrictions"
                                          "\n"
                                          "With respect to usage on HAIR mobile application or through the services, you agree that"
                                          "\n·    You shall not use any false e mail/ Mobilenumber."
                                          "\n·    You shall not impersonate."
                                          "\n·    Shall not violate any law rules."
                                          "\n·    You shall not misuse the OTP’S(One Time Password)"
                                          "\n·    You agree that you are responsible for the data charges due to the use of HAIR app."
                                          "\n·    Shall not be fraudulent or involve the use of counterfeit or stolen credit cards."
                                          "\n·    Shall not sell or otherwise transfer your account."
                                          "\n·    To solicit others to perform or participate in any unlawful acts."
                                          "\n·    To infringe upon or violate our intellectual property rights or intellectual property rights of others."
                                          "\n·    To upload or transmit viruses or any other type of malicious code that will or may be used that will affect any functionality of the application."
                                          "\n·    To collect or track personal information of others."
                                          "\n·    User shall have no right to copy, change alter, amend, reverse, engineer de compile, reverse translate, disassemble publish disclose display or make available or in any other manner decode the HAIR mobile app and website."
                                          "\n We reserve the right to terminate your account for the violation of restrictions,HAIR  shall not be responsible for non-availability of the HAIR mobile application during the periodic maintenance operations or any unplanned suspension of access to the HAIR application that may occur due to technical reasons or for any reason beyond HAIR control.HAIR accepts no liability for any errors or omissions , with respect to any information provided to the user. You agree not to reproduce , duplicate, copy ,sell, resell or exploit any part of the  application, use of any service , or access to the application or any content provided in the application through which the service is provided , without any express written permission by HAIR .HAIR shall not be responsible for any loss incurred due to "
                                          "any data theft from the storage (server)it will come under the procedure established by law .",
                                      textAlign: TextAlign.justify,
                                      textScaleFactor: 0.9,
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

  void cancelBooking(OrderClass oc,c){
    oc.updateOrderStatusCancel(oc.orderid,oc.vendorid,oc.userid,"vendor").then((value){

      print(oc.orderid);
      print(oc.userid);
      oc.updateOrderStatusAfterDoneCancel(oc.orderid,oc.vendorid, oc.userid,"vendor").then((value){

        sendNotifications("cancel","booking canceled on ${oc.selecteddate}","cancel","extra",oc.userid,oc.vendorid);

        Navigator.pop(c);
        fetchAppointments();
        showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Order Canceld",
              textStyle: TextStyle(
                  fontFamily: "ubuntub",
                  color: Colors.white,
                  fontSize: 15
              ),
            )
        );
      });

    });
  }




  @override
  void initState() {

    FirebaseFirestore.instance.collection("notification")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notification")
    .where("visible",isEqualTo: "false")
    .get().then((value){
      value.docs.forEach((element) {
        setState(() {
          _notiCount = _notiCount + 1;
        });
      });
    });
    print(userid);

    cb.fetchBusinessDetails(userid).then((value) {
      print(value.data());
      cb.vendorid = value.data()!['vendorid'];
      cb.businessid = value.data()!['businessid'];
      cb.date = value.data()!['date'];
      cb.time = value.data()!['time'];
      cb.activation = value.data()!['activation'];
      cb.businessFacilitys = value.data()!['businessFacilitys'];
      cb.businessTiming = value.data()!['businessTiming'];
      cb.businessTypeList = value.data()!['businessTypeList'];
      cb.treatmentMaleSeats = value.data()!['treatmentMaleSeats'];
      cb.businessName = value.data()!['businessName'];
      cb.businessWebsite = value.data()!['businessWebsite'];
      cb.hairMaleSeats = value.data()!['hairMaleSeats'];
      cb.hairFemaleSeats = value.data()!['hairFemaleSeats'];
      cb.treatmentMaleSeats = value.data()!['treatmentMaleSeats'];
      cb.treatmentFemaleSeats = value.data()!['treatmentFemaleSeats'];
      cb.totalStaff = value.data()!['totalStaff'];
      cb.salonTypeInGender = value.data()!['salonTypeInGender'];

      print(cb.businessTiming);

      if(cb.activation == "false")
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AccountVerification()));
      }
      fetchUserdata().then((value) {
        userData = value.data()!;
      });


    });

    FirebaseFirestore.instance.collection("business").doc(userid).get().then((value){
      Map<String, dynamic>? data = value.data();

      setState(() {
        category = data!['businessTypeList'];

        print(category[0]['0']);

        if(category[0]['0'] == '1')
        {
          spinnerItems.add('salon');
        }
        if(category[1]['1'] == '1')
        {
          spinnerItems.add('frelancing');
        }
        if(category[2]['2'] == '1')
        {
          spinnerItems.add('groom');
        }
        if(category[3]['3'] == '1')
        {
          spinnerItems.add('bridal');
        }
        if(category[4]['4'] == '1')
        {
          spinnerItems.add('massage/spa');
        }

        print(spinnerItems);

      });

    }).catchError((onError){
      print(onError);
    });


    FirebaseFirestore.instance.collection("categorys").doc(userid).collection("category").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        setState(() {
          categorySpinnerItems.add(element.data()['category']);
        });
      });
    });



    fetchAppointments();
    super.initState();
  }

  Widget getNotificationWidget()
  {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notification").doc(userid).collection("notification").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.data != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                children: snapshot.data!.docs.map((e){
                  return Container(
                    decoration:BoxDecoration(
                        color: getLightGrey(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(

                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "discoutn",
                          //   textScaleFactor: 0.9,
                          //   style: TextStyle(
                          //       color: getMateGold(),
                          //       fontFamily: "ubuntub",
                          //       fontSize: 20
                          //   ),
                          // ),
                          //
                          // SizedBox(height: 5,),
                          // Container(
                          //
                          //   child: data['discountavailable'] == 'true' ? Wrap(
                          //     children: [
                          //
                          //       Text(
                          //         "₹ ${data['price']}",
                          //         textScaleFactor: 0.9,
                          //         style: TextStyle(
                          //             color: Colors.grey[400],
                          //             fontFamily: "ubuntur",
                          //             fontSize: 15,
                          //             decoration: TextDecoration.lineThrough
                          //         ),
                          //       )
                          //     ],
                          //   ) : SizedBox(),
                          // ),
                        ],
                      ) ,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${e['title'][0].toUpperCase()}",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntub",

                          ),
                        ) ,
                        foregroundColor: getBlackMate(),
                      ),
                      title: Text(
                        //val.service_category
                        "${e['title']}",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntub",
                            fontSize: 18
                        ),
                      ),

                      subtitle: Text(
                        //val.service_category
                        "${e['body']}",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            fontFamily: "ubuntur",
                            fontSize: 13
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            );
          }
          else{
            return Container(
              child: Text("no notification at"),
            );
          }
        },
      ),
    );
  }


  List category = [];


  //service controllers ;

  TextEditingController _service_name = new TextEditingController(),
      _service_description = new TextEditingController(),
      _price = new TextEditingController(),
      _discount = new TextEditingController();


  GlobalKey<FormState> _service_form_update = new GlobalKey();
  bool _online_booking = true,
      _discount_on = false,
      _home_appointment = false;

  double scaleFactor = 0;

  String dropdownValue = 'select service type';

  List <String> spinnerItems = [
    'select service type',

  ];

  String categoryValue = 'select category type';

  List <String> categorySpinnerItems = [
    'select category type',
    'hair cut',
    'hair color',
    'shaving'
  ];


  String duartionValue = 'duration';

  List <String> duartionValueSpinnerItems = [
    'duration',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '110'
  ];

  String pricingValue = 'pricing type';

  List <String> pricingCalueSpinner = [
    'pricing type',
    'free',
    'fixed'
  ];

  GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();

  bool _sort = false;


  String genderSelection = "service for ?";

  List <String> genderSpinner = [
    'service for ?',
    'male',
    'female',
    'unisex'
  ];
  bool _service = false;

  int _notiCount = 0;
  

}