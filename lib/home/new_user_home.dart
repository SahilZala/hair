
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/barber/address_picker.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/create_business.dart';
import 'package:hair/home/salon_details.dart';
import 'package:hair/home/salon_list_category_vice.dart';
import 'package:hair/firebase/get_near_by_salon.dart';
import 'package:hair/home/service_rectifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:shimmer/shimmer.dart';

class NewUserHome extends StatefulWidget
{
  _NewUserHome createState ()=> _NewUserHome();
}
class _NewUserHome extends State<NewUserHome>
{
  double scaleFactor = 0;


  List<Widget> _buildScreens() {
    return [
      getHomePageContainer(),
      Container(),
      Container(),
      getProfileSection(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: ("home"),
        activeColorPrimary: getMateGold(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.calendar),
        title: ("orders"),
        activeColorPrimary: getMateGold(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.bell),
        title: ("bell"),
        activeColorPrimary: getMateGold(),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("profile"),
        activeColorPrimary: getMateGold(),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  PersistentTabController _controller = PersistentTabController(
      initialIndex: 0);


  @override
  Widget build(BuildContext context) {
    // _widgetOptions = <Widget>[
    //   getHomePageContainer(),
    //   Container(),
    //   Container(),
    //   getProfileSection(),
    // ];

    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;


    return Stack(
      children: [

        Container(
          width: MediaQuery.of(context).size.width,
          height: 1000,
          decoration: BoxDecoration(
              color: getBlackMate()
          ),
        ),



        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,

              title: Text("hair-salon",style: TextStyle(color: getBlackMate(),fontSize: 20,fontFamily: "ubuntum"),),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(
                  Icons.notifications,
                  size: 30,
                  color: getMateGold(),
                ))
              ],
              leading: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "images/h_icon.png",
                        )
                    )
                ),
              ),
            ),

            body: PersistentTabView(
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
        ),

        _pointer == 1 ? Center(child: CircularProgressIndicator()) : Container(),



      ],
    );

    // return SafeArea(
    //     child: Scaffold(
    //       key: _scaffold_key,
    //       backgroundColor: Colors.white,
    //       body: _widgetOptions[_current_index],
    //
    //       bottomNavigationBar: BottomNavigationBar(
    //         elevation: 2,
    //         onTap: (index) => setState(() => _current_index = index), items: [
    //         // BottomNavigationBarItem(
    //         //   backgroundColor: Colors.white,
    //         //   icon: Container(
    //         //     height: 30,
    //         //     width: 30,
    //         //     padding: EdgeInsets.all(0),
    //         //     decoration: BoxDecoration(
    //         //         image: DecorationImage(
    //         //             image: AssetImage("images/h_icon.png"),
    //         //             fit: BoxFit.cover
    //         //         )
    //         //     ),
    //         //
    //         //   ),
    //         //   title: Text("home",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur",fontSize: 15,),),
    //         // ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home,color: _current_index != 0 ? getGrey() : getMateGold(),),
    //           title: Text("",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur",fontSize: 0,),),
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.search,color: _current_index != 1 ? getGrey() : getMateGold(),),
    //           title: Text("",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur",fontSize: 0,),),
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.add_shopping_cart_outlined,color: _current_index != 2 ? getGrey() : getMateGold()),
    //           title: Text("",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur",fontSize: 0,),),
    //         ),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.account_circle_rounded, color:  _current_index != 3 ? getGrey() : getMateGold()),
    //             title: Text("",style: TextStyle(color: getBlackMate(),fontFamily: "ubuntur",fontSize: 0,),)
    //         ),
    //       ],
    //       ),
    //       appBar: AppBar(
    //         elevation: 0,
    //         backgroundColor: Colors.white,
    //
    //         title: Text("hair-salon",style: TextStyle(color: getBlackMate(),fontSize: 20,fontFamily: "ubuntum"),),
    //         actions: [
    //           IconButton(onPressed: (){}, icon: Icon(
    //             Icons.notifications,
    //             size: 30,
    //             color: getMateGold(),
    //           ))
    //         ],
    //         leading: Container(
    //           margin: EdgeInsets.all(5),
    //           decoration: BoxDecoration(
    //               image: DecorationImage(
    //                   image: AssetImage(
    //                     "images/h_icon.png",
    //                   )
    //               )
    //           ),
    //         ),
    //       ),
    //     ),
    // );
  }



  Widget getHomePageContainer()
  {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: new BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 60,),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  child: Text(
                    "Hello ${username['firstname']}!",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 30,
                        fontFamily: "ubuntub"
                    ),
                  ),
                ),
                getIntialPannelContainer(),
                SizedBox(height: 10,),

                Container(
                  width: MediaQuery.of(context).size.width,

                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Salon category",
                            textScaleFactor: 0.9,
                            style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntub",
                              fontSize: 22,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),


                getHorizontalCatrgoryContainer(),
                SizedBox(height: 20,),
                getServiceContainer(),

                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text("For function",textScaleFactor: 0.9,style: TextStyle(color: getBlackMate(),fontSize: 22,fontFamily: "ubuntub"),),
                ),

                getFuction(),

                SizedBox(height: 20,),

                getVisitSalonHistory(),

                SizedBox(height: 20,),


                Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text("Covid-19 Guidelines",textScaleFactor: 0.9,style: TextStyle(color: getBlackMate(),fontSize: 22,fontFamily: "ubuntub"),),
                ),
                getCovidGuideLines(),
                SizedBox(height: 20,),
              ],
            ),
          ),


          buildFloatingSearchBar(),


        ],
      ),
    );
  }

  Widget getIntialPannelContainer()
  {
    return Container(
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),

      child: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getInitialPannel("https://cdn.shopify.com/s/files/1/0676/6989/collections/Banner9_59da71b4-6f2a-414e-845d-a9a93202aa57.jpg?v=1510245000","left"),
            getInitialPannel("https://t4.ftcdn.net/jpg/03/24/53/19/360_F_324531906_TLLWTwd4sQcDOyg7r9xpBaFMLt8g8D4S.jpg","right"),
          ],
        ),
      ),
    );
  }

  Widget getCovidGuideLines()
  {
    return Container(
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: new BouncingScrollPhysics(),
        child: Row(
          children: [
            getCovidPannel("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_JabH7UbTrLqpPM_4wHTmfK0xs8LxtWvpAnpLMjyudf45B2-a370ssZOoVLNaK_3U-K8&usqp=CAU"),
            getCovidPannel("https://i.ytimg.com/vi/MZ41o9rOaiY/maxresdefault.jpg"),
            getCovidPannel("https://www.hul.co.in/Images/hul-covid-19-blue-banner-990x557_tcm1255-549912_w940.jpg"),
          ],
        ),
      ),
    );
  }

  Widget getFuction()
  {
    return Container(
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: new BouncingScrollPhysics(),
        child: Row(
          children: [
            getFunctionPanel("images/groom.jpg","Groom salon"),
            getFunctionPanel("images/bridal.jpg","Bridal salon"),

          ],
        ),
      ),
    );
  }

  Widget getInitialPannel(String imageurl,String position)
  {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
          height: 130,
          width: MediaQuery.of(context).size.width /1.2,

          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "$imageurl",
              ),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12
          ),
        ),

        Container(
          padding: position == "right" ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/3,0,10,0) : EdgeInsets.fromLTRB(10,0,MediaQuery.of(context).size.width/3,0),
          height: 130,
          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
          width: MediaQuery.of(context).size.width/1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Look Awesome & save some",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "ubuntub",
                  fontSize: 25
                ),
              ),

              SizedBox(height: 10,),
              Text(
                "Get Upto 50% Off",
                textScaleFactor: 0.9,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 15
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getCovidPannel(String imageurl)
  {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
          height: 130,
          width: 240,

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    "$imageurl",
                  ),
                  fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12
          ),
        ),


      ],
    );
  }


  Widget getFunctionPanel(String imageurl,salonname)
  {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
          height: 130,
          width: 240,

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "$imageurl",
                  ),
                  fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
          height: 130,
          width: 240,

          decoration: BoxDecoration(

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:  Alignment.bottomCenter,
               // 10% of the width, so there are ten blinds.
              colors: <Color>[
                Colors.transparent,
                Colors.transparent,
                Colors.black87,
              ], // red to yellow
              tileMode: TileMode.repeated, // repeats the gradient over the canvas
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 5),
          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
          height: 130,
          width: 240,
          alignment: Alignment.bottomLeft,

          child: Text(
            "$salonname",
            textScaleFactor: 0.9,
            style: TextStyle(
              color: getLightGrey(),
              fontSize: 25,
              fontFamily: "ubuntur",

            ),
          ),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10),
          ),
        )


      ],
    );
  }



  Widget getServiceContainer()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),

      width: MediaQuery.of(context).size.width,

      //  height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState){

                  return StreamBuilder(stream: getNearBySalon(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map?>> snapshot) {
                      if(snapshot.hasData)
                      {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Salon around you",
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                          color: getBlackMate(),
                                          fontFamily: "ubuntub",
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "see all",
                                        textAlign: TextAlign.right,
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                          color: getMateGold(),
                                          fontFamily: "ubuntur",
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),


                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: new BouncingScrollPhysics(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: snapshot.data!.docs.map((e){

                                  print(e.data()!['lat']);

                                  if((la != null && lo != null) && (la != "lat" && lo != "log") &&
                                      (e.data()!['lat'] != null && e.data()!['lat'] != null) && (e.data()!['lat'] != "lat" && e.data()!['lat'] != "log"))
                                  {
                                    double lat = double.parse(e.data()!['lat']);
                                    double log = double.parse(e.data()!['log']);

                                    double llat = double.parse(la);
                                    double llog = double.parse(lo);

                                    double distance = Geolocator.distanceBetween(
                                        lat, log, llat, llog);

                                    if (distance < 5000) {
                                      return getServicWidget(e.data());
                                    }
                                    else {
                                      return Container();
                                    }
                                  }
                                  else {
                                    return Container();
                                  }
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }
                      else {


                        return  SingleChildScrollView();

                      }
                    },

                  );


                  // return Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   // children: [
                  //   //   getServicWidget(),
                  //   //   getServicWidget(),
                  //   // ],
                  // );
                }
            ),
          ),


          // SizedBox(height: 30,),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //
          //   child: Container(
          //     margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
          //     width: MediaQuery.of(context).size.width,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Text(
          //             "Salon around you",
          //             textScaleFactor: 0.9,
          //             style: TextStyle(
          //               color: getBlackMate(),
          //               fontFamily: "ubuntub",
          //               fontSize: 22,
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Text(
          //             "see all",
          //             textAlign: TextAlign.right,
          //             textScaleFactor: 0.9,
          //             style: TextStyle(
          //               color: getMateGold(),
          //               fontFamily: "ubuntur",
          //               fontSize: 16,
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),

          SizedBox(height: 20,),

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: new BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // getServicWidget(),
                  // getServicWidget(),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget getCategoriesContainer()
  {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,


    );

  }

  Widget getServicWidget(Map? data)
  {
    print(data);
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SalonDetails(data!['vendorid'])));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        width: 225,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getLightGrey1()
        ),

        child: Column(
          children: [
            data?.length == 0 ? Container() : StreamBuilder(
              stream: getSalonGallaryImage(data!['vendorid']),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
                if(snapshot.hasData){

                  if(snapshot.data?.docs.toList().isNotEmpty == true) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(
                                snapshot.data?.docs.toList()[0]['url'],
                              ),
                              fit: BoxFit.cover
                          )
                      ),
                    );
                  }
                  else{
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                              ),
                              fit: BoxFit.cover
                          )
                      ),
                    );
                  }


                }
                else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: NetworkImage(
                              "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                  );
                }
              },
            ),

            SizedBox(
              height: 10,
            ),

            Row(
              children: [

                Expanded(
                  flex: 5,
                  child: Text(
                    "${data!['businessName']}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color : Colors.grey,
                        fontFamily: "ubuntur",
                        fontSize: 18
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: getMateGold(),
                      ),
                      Text(
                        "0",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color : getMateGold(),
                            fontFamily: "ubuntur",
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),


            SizedBox(
              height: 5,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: new BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 15,
                      color: getMateGold(),
                    ),

                    SizedBox(width: 2,),

                    Text(
                      "${data['address']}",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color : getMateGold(),
                          fontFamily: "ubuntur",
                          fontSize: 15
                      ),
                    ),

                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget getHorizontalCatrgoryContainer() {

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Wrap(

        alignment: WrapAlignment.spaceEvenly,
        spacing: 10,
        runSpacing: 15,
        runAlignment: WrapAlignment.start,
        children: [
          getHorizontalItem("images/cut.png", "hair cut" , (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalonListCategory("salon","salon","hair cut")));
          }),
          getHorizontalItem("images/razor.png", "shaving",(){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalonListCategory("salon","salon","shaving")));
          }),
          getHorizontalItem("images/newhaircolor.png", "hair color",(){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SalonListCategory("salon","salon","hair color")));
          }),
          getHorizontalItem("images/newmassage.png", "massage",(){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalonListCategory("salon","salon","massage")));
          }),
          // getHorizontalItem("images/cut.png", "hair cut",(){
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SalonListCategory()));
          // }),
          // getHorizontalItem("images/razor.png", "shaving",(){Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => SalonListCategory()));
          // }),
          // getHorizontalItem("images/bottole.png", "treatment",(){
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SalonListCategory()));
          // }),
          // getHorizontalItem("images/more.png", "more",(){
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SalonListCategory()));
          // }),
        ],
      ),
    );
  }


  Widget getHorizontalItem(icon, title , callback) {
    return GestureDetector(
      onTap: (){
        callback();
      },
      child: Container(

        child: Column(

          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(12),
              height: 56,
              width: 56,
              decoration: BoxDecoration(

                color: getLightGrey(),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Image.asset(icon, fit: BoxFit.cover,),
            ),

            SizedBox(height: 8,),
            Text(
              title,
              textAlign: TextAlign.center,
              textScaleFactor: 0.9, style: TextStyle(
                color: getBlackMate(),
                fontSize: 15,
                fontFamily: "ubuntur"
            ),

            ),
          ],
        ),
      ),
    );
  }


  void getUserName()
  {
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value){
          setState(() {
            username = value.data()!;
            la = value.data()!['lat'] == null ? "0" : value.data()!['lat'];
            lo = value.data()!['log'] == null ? "0" : value.data()!['log'];

            print(la);
            print(lo);
          });
    });
  }


  Widget getProfileSection() {
    return StatefulBuilder(
      builder: (BuildContext context1,
          void Function(void Function()) setState) {
        return SingleChildScrollView(
          physics: new BouncingScrollPhysics(),
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
                    child: _profilePointer == 0 ? CircleAvatar(
                      radius: 85,
                      backgroundImage: NetworkImage(
                        username['profile'] != null
                            ? username['profile']
                            : "",
                      ),
                    ) : CircularProgressIndicator(),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(username['firstname'], style: TextStyle(
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
                      child: Text("  Address", style: TextStyle(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddressPicker(FirebaseAuth.instance.currentUser!.uid,"user")));
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
                      child: Text("  User Details", style: TextStyle(
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
                          updateUsername();
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
                      child: Text(" Contact Support", style: TextStyle(
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
                      child: Text(" Terms and condition", style: TextStyle(
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
                      child: Text(" About us", style: TextStyle(
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
                      child: Text(" Rate us", style: TextStyle(
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
    );
  }


  @override
  void initState() {

    getUserName();



    super.initState();
  }


  void _showPickOptionsDialog(int comesFrom) {

    _scaffold_key.currentState!.showBottomSheet((context){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        color: getLightGrey(),

        child: SingleChildScrollView(
          physics: new BouncingScrollPhysics(),
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


  void updateUsername()
  {
    _firstname.text = username['firstname'];
    _lastname.text = username['lastname'];
    _scaffold_key.currentState!.showBottomSheet((context){
      return Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Form(
          key: _usernameForm,
          child: SingleChildScrollView(
            physics: new BouncingScrollPhysics(),

            child: Column(
              children: [

                SizedBox(
                  height: 10,
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5),

                  child: IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: getBlackMate(),
                      size: 30,
                    ), onPressed: () {
                      Navigator.pop(context);
                  },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextFormField(
                    controller: _firstname,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter first name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 20 / scaleFactor
                    ),

                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "first name",
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
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextFormField(
                    controller: _lastname,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter last name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: getBlackMate(),
                        fontSize: 20 / scaleFactor
                    ),

                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "last name",
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
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: getBlackMate(),
                borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(

                onPressed: (){
                  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid)
                      .update(
                    {
                      "firstname": _firstname.text,
                      "lastname": _lastname.text
                    }
                  ).whenComplete((){
                    setState(() {
                      getUserName();
                    });
                    Navigator.pop(context);
                  }).catchError((onError){

                  });

                },
                elevation: 0,
                padding: EdgeInsets.all(0),
                child: Text(
                  "UPDATE",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "ubuntur",
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
                SizedBox(height: 20,),


              ]
            ),
          ),
        ),
      );
    });
  }

  _loadPicker(ImageSource source, int comes) async {
    PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
    if (picked != null) {

      setState(() {
        _profilePointer = 1;
      });


      CreateBusiness cb = new CreateBusiness.fetch();
      cb.uploadProfileImage(File(picked.path), FirebaseAuth.instance.currentUser!.uid).then((value){
        value.ref.getDownloadURL().then((value){
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"profile": value.toString()}).whenComplete((){

            getUserName();

            _profilePointer = 0;
            });
          });

        });
    }
    // Navigator.pop(context);
  }

  int _profilePointer = 0;



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
                                physics: new BouncingScrollPhysics(),
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
                                physics: new BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    Text(
                                      "Hair is an online destination for salons and their clients. It's an online booking appointment app. It is a pool for both salons and customers. Professionals can show case their work, connect with existing clients and build their business.Clients can discover new services and providers, book appointments online, and get inspired.",
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

  Widget getVisitSalonHistory()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),

      width: MediaQuery.of(context).size.width,

      //  height: MediaQuery.of(context).size.height,
      child: Column(

        children: [

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState){

                  if(FirebaseAuth.instance.currentUser != null) {

                    return StreamBuilder(stream: getHistoryVisit(
                        FirebaseAuth.instance.currentUser!.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map?>> snapshot) {
                        if (snapshot.data != null) {
                          return Column(
                            children: [

                              snapshot.data!.docs.length != 0 ? Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,

                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 25),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Recent Visit",
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            color: getBlackMate(),
                                            fontFamily: "ubuntub",
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ) : Container(),


                              SingleChildScrollView(
                                physics: new BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: snapshot.data!.docs.map((e) {
                                    return Container(
                                        child: StreamBuilder(
                                          stream: getSalonDetails(
                                              e.data()!['salonid']),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot<
                                                  Map<dynamic,
                                                      dynamic>>> snapshot) {
                                            return getServicWidget(
                                                snapshot.data?.data());
                                          },
                                        )
                                    );
                                  }).toList(),
                                ),
                              ),


                              SingleChildScrollView(
                                physics: new BouncingScrollPhysics(),

                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: snapshot.data!.docs.map((e) {
                                    print(e.data());


                                    return Container();

                                    // return getServicWidget(e);

                                  }).toList(),
                                ),
                              ),


                            ],
                          );
                        }
                        else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },

                    );
                  }
                  else{
                    return Container();
                  }
                }
            ),
          ),


          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // getServicWidget(),
                  // getServicWidget(),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }


  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      margins: EdgeInsets.all(10),
      hint: 'Search salon name here',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: MediaQuery.of(context).size.width,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        setState(() {
          searchKey = query;
        });
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Container(height: 20,width: 20,child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(CupertinoIcons.slider_horizontal_3), onPressed: () {  },)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceRectifier()));
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: StreamBuilder(
              
                stream: searchKey.length == 0 ? getNearBySalon() : FirebaseFirestore.instance.collection("business")
                    .where("businessName",isEqualTo: searchKey)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map?>> snapshot)
                {
                  if(snapshot.hasData) {



                    var mainData = snapshot.data?.docs.toList();

                    if(mainData!.isNotEmpty) {
                      List<Map> actualData = [];

                      mainData.forEach((element) {
                        var pp = element.data();

                        print(pp!['lat']);

                        if (pp['lat'] != 'lat' || pp['log'] != 'log') {
                          double lat = double.parse(pp['lat']);
                          double log = double.parse(pp['log']);

                          double llat = double.parse(la);
                          double llog = double.parse(lo);


                          double distance = Geolocator.distanceBetween(
                              lat, log, llat, llog);

                          pp['distance'] = distance;

                          actualData.add(pp);
                        }
                      });

                      actualData.sort((a, b) =>
                      (a['distance'] >= b['distance']
                          ? 1
                          : -1));

                      return SingleChildScrollView(

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: actualData.map((e) {
                            return barberShop(e);
                            //return getServicWidget(e);
                          }).toList(),
                        ),
                      );
                    }
                    else{
                      return Column(children: [Padding(padding: EdgeInsets.all(10),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),


                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                           Shimmer.fromColors(
                              baseColor: getLightGrey1(),
                              highlightColor: Colors.white,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.red
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(baseColor: getLightGrey1(),
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.grey,
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 10,),
                                  Shimmer.fromColors(baseColor: getLightGrey1(),
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/3,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.grey,
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Text('            ', style: TextStyle(fontSize: 11, fontFamily: 'Ubuntu')),
                                      SizedBox(width: 40,),
                                      Expanded(
                                        child: Shimmer.fromColors(
                                          baseColor: getLightGrey1(),
                                          highlightColor: Colors.white,
                                          child: Container(
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.orange
                                              ),
                                              child: Center(child: Text('Book Now',style: TextStyle(fontSize: 11, fontFamily: 'Ubuntu', color: Colors.white)),
                                              )
                                          ),
                                        ),
                                      )],)
                                ],
                              ),
                            )
                          ],
                        ),
                      ))]);
                    }
                  }
                  else{
                   return CircularProgressIndicator();
                  }
                }
            ),
            // child: Column(
            //
            //   mainAxisSize: MainAxisSize.min,
            //   children: Colors.accents.map((color) {
            //     return Container(height: 112, color: color);
            //   }).toList(),
            // ),
          ),
        );
      },
    );
  }


  Widget barberShop(data)
  {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
      padding: const EdgeInsets.only(left: 15, right: 15),


      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white
      ),
      child: Row(
        children: [
          SizedBox(width: 8,),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black
              ),
              child: Image.asset('images/hicon3.png', height: 100, width: 100, fit: BoxFit.contain,)),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text("${data['businessName']}        ", style: TextStyle(fontSize: 14, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text("${data['address']}", style: TextStyle(fontSize: 10, fontFamily: 'Ubuntu'),),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 17, color: Colors.amber,),
                    SizedBox(width: 5,),
                    Text('${(data['distance'] / 1000).toInt()} km', style: TextStyle(fontSize: 11, fontFamily: 'Ubuntu')),
                    SizedBox(width: 40,),
                    Expanded(
                      child: Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.orange
                          ),
                          child: Center(child: Text('Book Now',style: TextStyle(fontSize: 11, fontFamily: 'Ubuntu', color: Colors.white)),
                          )
                      ),
                    )],)
              ],
            ),
          )
        ],
      ),
    );
  }



  GlobalKey<ScaffoldState> _scaffold_key  = GlobalKey<ScaffoldState>();
  int _current_index = 0;
  var _widgetOptions = [];
  Map username = new Map();
  String la = "0",lo = "0";


  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();

  GlobalKey<FormState> _usernameForm = GlobalKey<FormState>();

  int recentVisit = 0;
  String searchKey = "";

  int _pointer = 0;
}