import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/get_near_by_salon.dart';
import 'package:hair/home/salon_details.dart';
import 'package:hair/home/service_rectifier.dart';
import 'package:shimmer/shimmer.dart';

class SalonListing extends StatefulWidget
{
  String city;
  int rating;
  double lat , log;
  int distance;


  SalonListing(this.city, this.rating, this.lat, this.log, this.distance);

  _SalonListing createState ()=> _SalonListing(city,rating, lat,log,distance);
}

class _SalonListing extends State<SalonListing>
{

  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ServiceRectifier()));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Container(

            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              physics: new BouncingScrollPhysics(),
              child: Column(
                children: [
                  getRectifier()
                ],
              ),
            ),
          ),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: getBlackMate(),
            title: Text(
              "Non",
              style: TextStyle(
                color: getMateGold(),
                fontFamily: "ubuntur",
                fontSize: 25,
              ),
            ),
          ),

        ),
      ),
    );
  }


  Widget getRectifier()
  {
    return StreamBuilder(stream: getNearBySalon(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map?>> snapshot) {
      if(snapshot.hasData)
      {
        var mainData = snapshot.data?.docs.toList();

        if(mainData?.length != 0) {
          List<Map> actualData = [];

          mainData?.forEach((element) {
            var pp = element.data();

            print(pp!['lat']);

            if (pp['lat'] != 'lat' || pp['log'] != 'log') {
              double lat1 = double.parse(pp['lat']);
              double log1 = double.parse(pp['log']);

              double llat = lat;
              double llog = log;


              double distance1 = Geolocator.distanceBetween(
                  lat1, log1, llat, llog);

              pp['distance'] = distance1;

              if((distance1 / 1000).toInt() < distance)
              {
                  actualData.add(pp);

                  print("sasasssasasasa ${actualData.length}");
              }
            }
          });

          actualData.sort((a, b) => (a['distance'] >= b['distance'] ? 1 : -1));

         // actualData.where((element) => int.parse(element['distance']) <= distance ? true : false);

         // print(" kudkf $distance");

          return SingleChildScrollView(
            physics: new BouncingScrollPhysics(),
            child: Column(
              children: actualData.map((e) {

                return barberShop(e);
                //return getServicWidget(e);
              }).toList(),
            ),
          );
        }
        else{
          return Shimmer.fromColors(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: getLightGrey1(),
              ),
            ),
            baseColor: getLightGrey1(),
            highlightColor: Colors.white,);
        }
        // return SingleChildScrollView(
        //     physics: new BouncingScrollPhysics(),
        //   child: Column(
        //     children: snapshot.data!.docs.map((e){
        //
        //
        //
        //
        //       if((la != null && lo != null) && (la != "lat" && lo != "log") &&
        //           (e.data()!['lat'] != null && e.data()!['lat'] != null) && (e.data()!['lat'] != "lat" && e.data()!['lat'] != "log"))
        //         {
        //           double lat = double.parse(e.data()!['lat']);
        //           double log = double.parse(e.data()!['log']);
        //
        //           double llat = double.parse(la);
        //           double llog = double.parse(lo);
        //
        //
        //           double distance = Geolocator.distanceBetween(
        //               lat, log, llat, llog);
        //
        //
        //           if (distance < 5000) {
        //             return getServiceListContainer(e);
        //           }
        //           else {
        //             return Container();
        //           }
        //         }
        //       else {
        //         return Container();
        //       }
        //
        //      // return
        //
        //     }).toList(),
        //   )
        // );
      }
      else {
        return Container(
            child: Text("No data found",style: TextStyle(color: getBlackMate(),fontSize: 20),)
        );
      }
    });
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
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context) => SalonDetails("${data['vendorid']}")
                          ));
                        },
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
    );
  }



  _SalonListing(this.city, this.rating, this.lat, this.log, this.distance);


  String city;
  int rating;
  double lat , log;
  int distance;

}