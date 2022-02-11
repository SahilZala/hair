// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// import '../colors.dart';
//
// class SalonDetails extends StatefulWidget
// {
//   _SalonDetails createState ()=> _SalonDetails();
// }
// class _SalonDetails extends State<SalonDetails> with SingleTickerProviderStateMixin
// {
//   @override
//   Widget build(BuildContext context) {
//    return SafeArea(
//        child: Stack(
//          children: [
//            Scaffold(
//              backgroundColor: getBlackMate(),
//              body: Container(
//
//                height: MediaQuery.of(context).size.height,
//                width: MediaQuery.of(context).size.width,
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
//                ),
//
//                child: SingleChildScrollView(
//                  child: Column(
//                    children: [
//                      getSalonContainer()
//                    ],
//                  ),
//                ),
//              ),
//              appBar: AppBar(
//                elevation: 0,
//                backgroundColor: getBlackMate(),
//                title: Text(
//                  "Hair Cut",
//                  textScaleFactor: 0.9,
//                  style: TextStyle(
//                    color: getMateGold(),
//                    fontFamily: "ubuntur",
//                    fontSize: 25,
//                  ),
//                ),
//              ),
//            ),
//          ],
//        )
//    );
//   }
//
//   Widget getSalonContainer()
//   {
//     return Container(
//       padding: EdgeInsets.all(15),
//       width: MediaQuery.of(context).size.width,
//
//       child: Column(
//         children: [
//           getSliderContainer(),
//           getSalonDetails()
//         ],
//       ),
//     );
//   }
//
//   Widget getSliderContainer()
//   {
//     return getSliderWidget();
//   }
//
//   Widget getSliderWidget() {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: getLightGrey(),
//              borderRadius: BorderRadius.circular(10),
//           ),
//           width: MediaQuery
//               .of(context)
//               .size
//               .width,
//           child: CarouselSlider(
//             options: CarouselOptions(
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 1.0,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 reverse: false,
//                 autoPlay: true,
//                 autoPlayInterval: Duration(seconds: 3),
//                 autoPlayAnimationDuration: Duration(milliseconds: 800),
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged: (index, s) {
//                   setState(() {
//                     _current = index;
//                   });
//                 }
//             ),
//             items: imgList.map((item) => getSliderItem(item)).toList(),
//
//           ),
//         ),
//         //getSliderItem(),
//
//         const SizedBox(
//           height: 10,
//         ),
//         Container(
//
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: map<Widget>(imgList, (index, url) {
//               return Container(
//                 margin: EdgeInsets.all(2),
//                 width: 10.0,
//                 height: 10.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                       color: _current == index ? getMateGold() : const Color
//                           .fromRGBO(102, 102, 102, 1)),
//                   color: _current == index ? getMateGold() : Colors.white,
//                 ),
//               );
//             }),
//           ),
//         ),
//
//
//
//       ],
//     );
//   }
//
//
//
//   Widget getSliderItem(String url) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width,
//       height: 180,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(
//             url
//           ),
//           fit: BoxFit.fill,
//         ),
//         borderRadius: BorderRadius.circular(10)
//       ),
//     );
//   }
//
//   Widget getSalonDetails()
//   {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Tunning Salon",
//               style: TextStyle(
//                 color: getBlackMate(),
//                 fontFamily: "ubuntum",
//                 fontSize: 30,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             SizedBox(height: 10,),
//
//             Row(
//               children: [
//                 RatingBar.builder(
//                   initialRating: 3,
//                   minRating: 1,
//                   itemSize: 20,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                   itemBuilder: (context, _) => Icon(
//                     Icons.star,
//                     color: getMateGold(),
//                   ),
//                   onRatingUpdate: (rating) {
//                     print(rating);
//                   },
//                 ),
//
//                 Text(
//                   "3.0",
//                   style: TextStyle(
//                     color: getMateGold(),
//                     fontSize: 20,
//                     fontFamily: "ubuntub",
//
//                   ),
//                 ),
//
//                 SizedBox(width: 5,),
//                 Container(
//                   height: 15,
//                   width: 2,
//                   margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                   color: Colors.grey[400],
//                 ),
//
//                 SizedBox(width: 5,),
//
//                 Text(
//                   "( 1,000 reviews )",
//                   style: TextStyle(
//                     color: getGrey(),
//                     fontSize: 15,
//                     fontFamily: "ubuntul",
//
//                   ),
//                 ),
//
//               ],
//             ),
//
//             SizedBox(height:10,),
//
//             Row(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   size: 15,
//                   color: getMateGold(),
//                 ),
//
//                 SizedBox(width: 5,),
//
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     "salon full address ",
//                     textScaleFactor: 0.9,
//
//                     style: TextStyle(
//                         color : getMateGold(),
//                         fontFamily: "ubuntur",
//                         fontSize: 15
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//
//             SizedBox(
//               height: 10,
//             ),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     child: Row(
//                       children: [
//                         Icon(Icons.watch_later_outlined,
//                           color: getBlackMate(),
//                           size: 15,
//                         ),
//                         SizedBox(width: 5,),
//                         Expanded(
//                           child: Text(
//                             "10 : 00 AM | 10 : 00 PM",
//                             style: TextStyle(
//                               color: getBlackMate(),
//                               fontSize: 15,
//                               fontFamily: "ubuntur",
//                             ),
//                           ),
//                         ),
//
//
//                       ],
//                     )
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.centerRight,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "At Home / At Site ",
//                           style: TextStyle(
//                             color: getBlackMate(),
//                             fontSize: 15,
//                             fontFamily: "ubuntur"
//                           ),
//                         )
//                       ],
//                     ),
//
//                   ),
//                 )
//               ],
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 2,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             Text(
//               "About Tunning Salon",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color:  getBlackMate(),
//                 fontFamily: "ubuntub",
//                 fontSize: 20,
//               ),
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//
//             Text(
//               "brief information about tunning saloon",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color:  getGrey(),
//                 fontFamily: "ubuntul",
//                 fontSize: 18,
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             Text(
//               "Facilities",
//               textScaleFactor: 0.9,
//               style: TextStyle(
//                 color:  getBlackMate(),
//                 fontFamily: "ubuntub",
//                 fontSize: 20,
//               ),
//             ),
//
//             SizedBox(
//               height: 5,
//             ),
//
//
//             Container(
//               width: MediaQuery.of(context).size.width,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                         height: 35,
//                         width: 35,
//                         margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: getLightGrey1(),
//                             borderRadius: BorderRadius.circular(5)
//                         ),
//                         child: Image.asset("images/ac.png")
//                     ),
//
//                     Container(
//                         height: 35,
//                         width: 35,
//                         margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: getLightGrey1(),
//                             borderRadius: BorderRadius.circular(5)
//                         ),
//                         child: Image.asset("images/parking.png")
//                     ),
//
//                     Container(
//                         height: 35,
//                         width: 35,
//                         margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: getLightGrey1(),
//                             borderRadius: BorderRadius.circular(5)
//                         ),
//                         child: Image.asset("images/wifi.png")
//                     ),
//
//                     Container(
//                         height: 35,
//                         width: 35,
//                         margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: getLightGrey1(),
//                             borderRadius: BorderRadius.circular(5)
//                         ),
//                         child: Image.asset("images/music.png")
//                     ),
//
//
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/sanitizer.png")
//                     // ),
//                     //
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/sterilizer.png")
//                     // ),
//                     //
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/online_pay.png")
//                     // ),
//                     //
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/appointement.png")
//                     // ),
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/temprature.png")
//                     // ),
//                     //
//                     // Container(
//                     //     height: 35,
//                     //     width: 35,
//                     //     margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
//                     //     padding: EdgeInsets.all(5),
//                     //     decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(5)
//                     //     ),
//                     //     child: Image.asset("images/face_mask.png")
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//
//             TabBar(
//               indicatorColor: Colors.black,
//               unselectedLabelColor: getBlackMate(),
//               labelColor: getMateGold(),
//               onTap: (index){
//                 setState(() {
//                   _selectedTabbar = index;
//                 });
//               },
//               tabs: [
//                 Tab(
//                     icon: Icon(
//                         Icons.widgets_rounded
//                     )
//                 ),
//                 Tab(
//                   icon: Icon(Icons.image_sharp),
//                 ),
//                 Tab(
//                   icon: Icon(Icons.reviews  ),
//                 )
//               ],
//               controller: _tabController,
//               indicatorSize: TabBarIndicatorSize.tab,
//             ),
//
//             Builder(builder: (_) {
//               if (_selectedTabbar == 0) {
//                 return ExpansionPanelList(
//                   animationDuration: Duration(milliseconds:1000),
//                   dividerColor: getGrey(),
//                   elevation: 0,
//
//                   children: [
//                     getExpansionPannel(0),
//                     getExpansionPannel(1),
//                   ],
//                   expansionCallback: (int item, bool status) {
//
//                     setState(() {
//
//                       itemData[item].expanded = !status;
//                     });
//                   },
//                 );//1st custom tabBarView
//               } else if (_selectedTabbar == 1) {
//                 return Container();//2nd tabView
//               } else {
//                 return Container(); //3rd tabView
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ExpansionPanel getExpansionPannel(index)
//   {
//     return ExpansionPanel(
//
//       body: Container(
//
//         child: Column(
//           crossAxisAlignment:CrossAxisAlignment.start,
//           children: <Widget>[
//
//             getServiceList(),
//             getServiceList(),
//
//
//           ],
//         ),
//       ),
//       headerBuilder: (BuildContext context, bool isExpanded) {
//         return Container(
//           margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
//
//           child: Text(
//             itemData[index].headerItem,
//             style: TextStyle(
//               color:itemData[index].colorsItem,
//               fontSize: 20,
//               fontFamily: "ubuntub"
//             ),
//           ),
//         );
//       },
//       isExpanded: itemData[index].expanded,
//     );
//
//   }
//
//   Widget getServiceList()
//   {
//     return Container(
//       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               child: Text(
//                   "Rainbow hair style",
//                 textScaleFactor: 0.9,
//                 style: TextStyle(
//                   fontSize: 15,
//
//                   color: getBlackMate(),
//
//                 ),
//               ),
//             ),
//           ),
//
//           Expanded(
//             flex: 1,
//             child: Container(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Rs. 100/-",
//                 textScaleFactor: 0.9,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: getMateGold(),
//
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//
//
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }
//
//
//   //declaration
//   int _current = 0;
//   final List<String> imgList = [
//     'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
//     'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg',
//     'https://static.businessworld.in/article/article_extra_large_image/1589448910_mKTyMh_salon_mangalore4.jpg'
//   ];
//
//
//   late TabController _tabController;
//   int _selectedTabbar = 0;
//
//   @override
//   void initState() {
//     _tabController = new TabController(length: 3, vsync: this);
//   }
//
//   int index = 0;
//   List<ItemModel> itemData = <ItemModel>[
//     ItemModel(
//         headerItem: 'Hair Cut',
//         discription:
//         "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
//         colorsItem: getBlackMate(),
//         img: 'images/h_icon.png'
//     ),
//
//     ItemModel(
//         headerItem: 'Hair Cut',
//         discription:
//         "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
//         colorsItem: getBlackMate(),
//         img: 'images/h_icon.png'
//     ),
//   ];
//
//
// }
//
// class ItemModel {
//   bool expanded;
//   String headerItem;
//   String discription;
//   Color colorsItem;
//   String img;
//
//   ItemModel({this.expanded: false, required this.headerItem, required this.discription,required this.colorsItem,required this.img});
// }