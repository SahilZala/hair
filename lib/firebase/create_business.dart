import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hair/firebase/services.dart';

class CreateBusiness
{
  String vendorid= "",businessid = "";
  String businessName = "",businessWebsite = "";
  List businessTypeList = [];
  List businessFacilitys = [];
  String hairMaleSeats = "",treatmentMaleSeats = "",hairFemaleSeats = "",treatmentFemaleSeats = "",totalStaff = "",salonTypeInGender = "";
  List businessTiming = [];
  String time = "",date = "",activation = "";
  String gstnumber = "0";
  String address = "address";



  CreateBusiness.service(String userid,String busiid,String tim,String dat){
    this.vendorid = userid;
    this.businessid = busiid;
    this.time = tim;
    this.date = dat;
  }

  CreateBusiness.fetch();

  CreateBusiness(
      this.vendorid,
      this.businessid,
      this.businessName,
      this.businessWebsite,
      this.businessTypeList,
      this.businessFacilitys,
      this.hairMaleSeats,
      this.treatmentMaleSeats,
      this.hairFemaleSeats,
      this.treatmentFemaleSeats,
      this.totalStaff,
      this.salonTypeInGender,
      this.businessTiming,
      this.time,
      this.date,
      this.activation,
      this.gstnumber,
      this.address);

  Future<String> pushData() async =>
      FirebaseFirestore.instance.collection("business").doc(vendorid).set({
        "vendorid": vendorid,
        "businessid": businessid,
        "businessName": businessName,
        "businessWebsite": businessWebsite,
        "businessTypeList": businessTypeList,
        "businessFacilitys": businessFacilitys,
        "hairMaleSeats": hairMaleSeats,
        "treatmentMaleSeats": treatmentMaleSeats,
        "hairFemaleSeats": hairFemaleSeats,
        "treatmentFemaleSeats": treatmentFemaleSeats,
        "totalStaff": totalStaff,
        "salonTypeInGender":salonTypeInGender,
        "businessTiming": businessTiming,
        "time": time,
        "date": date,
        "activation": activation,
        "gstnumber": gstnumber,
        "address": address
      }).then((value) {
        return "done";
      }).onError((error, stackTrace) {
        return error.toString();
      });
  
  Future<dynamic> createServices(Services services,String serviceid)
  async => FirebaseFirestore.instance.collection("services")
      .doc(vendorid)
      .collection("service")
      .doc(serviceid)
      .set({
    "vendorid":vendorid,
    "businessid": businessid,
    "serviceid": serviceid,
    "servicename": services.service_name,
    "servicetype": services.service_type,
    "servicedescription": services.service_description,
    "servicecategory": services.service_category,
    "servicegender": services.service_gender,
    "onlinebooking": services.online_booking,
    "serviceduration": services.service_duration,
    "pricingtype": services.pricing_type,
    "price": services.price,
    "discountavailable": services.discount_available,
    "discount": services.discount,
    "homeappointment": services.home_appointment,
    "seattype": services.seat_type,
    "time": time,
    "date": date,
    "activation": "true"

  }).whenComplete((){
    return "done";
  }).onError((error, stackTrace) {
    return stackTrace.toString();
  });

  Future<TaskSnapshot> uploadProfileImage(File _image,String userid)
  async {
    return await FirebaseStorage.instance.ref().child(userid).child("profile").putFile(_image);
  }

  Future<TaskSnapshot> uploadSalonImage(File _image,String userid,String _imageName)
  async {
    return await FirebaseStorage.instance.ref().child(userid).child(_imageName).putFile(_image);
  }

  Future<DocumentSnapshot<Map>> fetchBusinessDetails(String vid)
  async => await FirebaseFirestore.instance.collection("business").doc(vid).get();


  Future<dynamic> updateService(Services services,String serviceid)
  async => FirebaseFirestore.instance.collection("services")
      .doc(vendorid)
      .collection("service")
      .doc(serviceid)
      .update({
    "vendorid":vendorid,
    "businessid": businessid,
    "serviceid": serviceid,
    "servicename": services.service_name,
    "servicetype": services.service_type,
    "servicedescription": services.service_description,
    "servicecategory": services.service_category,
    "servicegender": services.service_gender,
    "onlinebooking": services.online_booking,
    "serviceduration": services.service_duration,
    "pricingtype": services.pricing_type,
    "price": services.price,
    "discountavailable": services.discount_available,
    "discount": services.discount,
    "homeappointment": services.home_appointment,
    "seattype": services.seat_type,
    "time": time,
    "date": date,
    "activation": "true"

  }).whenComplete((){
    return "done";
  }).onError((error, stackTrace) {
    return stackTrace.toString();
  });
}