import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:location/location.dart' as loc;
class AddressPicker extends StatefulWidget
{
  String userid;

  String type;

  AddressPicker(this.userid,this.type);

  _AddressPicker createState ()=> _AddressPicker(userid,type);
}

class _AddressPicker extends State<AddressPicker>
{
  String userid;
  String type;
  _AddressPicker(this.userid,this.type);

  CameraPosition _cameraPosition = new CameraPosition(target: LatLng(0,0) ,zoom: 1);
  Completer<GoogleMapController> _controller = Completer();


  Future<bool> _onWillPop() async{

    if(type == 'business')
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BarberDashboard(userid)));
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => NewUserHome()));
    }
    return false;
  }



  loc.Location location = loc.Location();//explicit reference to the Location class
  Future _checkGps() async {
    if (!await location.serviceEnabled()) {

      location.requestService();
    }
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

              child: GoogleMap(

                mapType: MapType.normal,
                initialCameraPosition: _cameraPosition,

                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),

            floatingActionButton: FloatingActionButton(onPressed: () {

              _determinePosition();
              },

              backgroundColor: getBlackMate(),
              child: Icon(
                Icons.add_location_sharp,
                size: 20,
                color: getMateGold(),
              ),


            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          )
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _checkGps();

    _determinePosition();


  }

  void _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }

      GeoCode geoCode = new GeoCode();
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) {
        debugPrint('location: ${position.latitude}');
        Address address = new Address();
        setState(() async {
          _cameraPosition = new CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 8);
          final GoogleMapController controller = await  _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

          if(type == 'user') {
            FirebaseFirestore.instance.collection("users")
                .doc(userid)
                .update({
              'lat': position.latitude.toString(),
              'log': position.longitude.toString()
            });
          }
          else{
            FirebaseFirestore.instance.collection("business")
                .doc(userid)
                .update({
              'lat': position.latitude.toString(),
              'log': position.longitude.toString()
            });
          }
        });
      });

    }
    catch(ex)
    {
      print(ex);
    }
  }
}