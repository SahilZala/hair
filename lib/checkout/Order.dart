import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair/checkout/time_date_selection.dart';
import 'package:hair/checkout/time_date_selection_new.dart';
import 'package:uuid/uuid.dart';

class OrderClass
{
  String userid = "";
  String vendorid = "";
  List<String> serviceid = [];

  String seattype = "";
  String selecteddate = "";
  String seatnumber = "";
  String gender = "";


  String starttime = "";
  String endtime = "";
  String servicestatus = "";
  String totalduration = "";
  String slotcount = "";

  String total = "0";
  String disount = "0";
  String tax = "0";
  String finaltotal = "0";

  String orderid = "id";

  String paymentstatus = "incomplete";

  String lat = "0";
  String log = "0";
  String address = "address";

  String serviceplace = "at salon";

  String servicetype = "service";

  SplayTreeMap<String, NewSlots> data = SplayTreeMap<String, NewSlots>();

  OrderClass(
      this.userid,
      this.vendorid,
      this.serviceid,
      this.seattype,
      this.selecteddate,
      this.seatnumber,
      this.gender,
      this.starttime,
      this.endtime,
      this.servicestatus,
      this.totalduration,
      this.slotcount,
      this.data,
      this.lat,
      this.log,
      this.address,
      );


  OrderClass.check();

  Future<void> bookeService()
  {

    Map<String,Map<String,String>> selectedData = Map();

    data.forEach((key, value)
    {
      selectedData[key] = {
        "start": "${value.start}",
        "status": "${value.status}"
      };
    });


    orderid = Uuid().v1().toString();
    return FirebaseFirestore.instance
        .collection("Orders")
        .doc(vendorid)
        // .collection(seattype)
        // .doc(selecteddate)
        // .collection(gender)
        // .doc(seatnumber)
        .collection("order")
        .doc(
        orderid
    ).set({
      "userid": userid,
      "vendorid": vendorid,
      "serviceid": serviceid,
      "seattype": seattype,
      "selecteddate": selecteddate,
      "seatnumber": seatnumber,
      "gender" : gender,
      "starttime": starttime,
      "endtime": endtime,
      "servicestatus": servicestatus,
      "totalduration": totalduration,
      "slotcount": slotcount,
      "slots": selectedData,
      "orderid": orderid,

      "total": total,
      "discount": disount,
      "tax": tax,
      "finaltotal": finaltotal,
      "paymentstatus": paymentstatus,
      "time": "time",
      "date": "date",
      "activation": "true",
      "lat": lat,
      "log": log,
      "address": address,
      "serviceplace" : serviceplace,
      "servicetype": servicetype

    });
  }




  Future<QuerySnapshot<Map>> checkOrderData(String bid,String date,String gender,String seat,String seattype)
  {
    return FirebaseFirestore.instance.collection("Orders")
        .doc(bid)
        // .collection(seattype)
        // .doc(date)
        // .collection(gender)
        // .doc(seat)
        .collection("order")
        .where("seattype",isEqualTo: seattype)
        .where("selecteddate",isEqualTo: date)
        .where("gender",isEqualTo: gender)
        .where("servicestatus",isEqualTo: "booked")
        .where("seatnumber",isEqualTo: seat)
        .get();
  }

  Future<QuerySnapshot<Map>> checkOrderDataNew(String bid,String date,String gender,String seattype)
  {
    return FirebaseFirestore.instance.collection("Orders")
        .doc(bid)
    // .collection(seattype)
    // .doc(date)
    // .collection(gender)
    // .doc(seat)
        .collection("order")
        .where("seattype",isEqualTo: seattype)
        .where("selecteddate",isEqualTo: date)
        .where("gender",isEqualTo: gender)
        .where("servicestatus",isEqualTo: "booked")
        .get();
  }


  Future<void> createOrderDoc() async{
    return await FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .set({
      "key" : vendorid,
    });
  }


  Future<void> afterPayment() async{
    return await FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(orderid)
        .update({
      "servicestatus" : servicestatus,
      "paymentstatus" : paymentstatus
    });
  }


  Future<void> afterPaymentReschedule() async{
    Map<String,Map<String,String>> selectedData = Map();

    data.forEach((key, value)
    {
      selectedData[key] = {
        "start": "${value.start}",
        "status": "${value.status}"
      };
    });

    return await FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(orderid)
        .update({
      "servicestatus" : servicestatus,
      "paymentstatus" : paymentstatus,

      "userid": userid,
      "vendorid": vendorid,
      "serviceid": serviceid,
      "seattype": seattype,
      "selecteddate": selecteddate,
      "seatnumber": seatnumber,
      "gender" : gender,
      "starttime": starttime,
      "endtime": endtime,
      "servicestatus": servicestatus,
      "totalduration": totalduration,
      "slotcount": slotcount,
      "slots": selectedData,
      "orderid": orderid,
    });
  }

  // Future<QuerySnapshot<Map>> getMyOrders(String bid,String date,String gender,String seat,String seattype)
  // {
  //   return FirebaseFirestore.instance.collection("Orders").doc(bid).
  // }


  Future<void> afterFailure() async{
    return await FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(orderid)
        .update({
      "servicestatus" : servicestatus,
      "paymentstatus" : paymentstatus
    });
  }


  Future<void> placeMyOrder()
  {
    Map<String,Map<String,String>> selectedData = Map();

    data.forEach((key, value)
    {
      selectedData[key] = {
        "start": "${value.start}",
        "status": "${value.status}"
      };
    });

    return FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .collection("myorder")
        .doc(orderid)
        .set({
      "userid": userid,
      "vendorid": vendorid,
      "serviceid": serviceid,
      "seattype": seattype,
      "selecteddate": selecteddate,
      "seatnumber": seatnumber,
      "gender" : gender,
      "starttime": starttime,
      "endtime": endtime,
      "servicestatus": servicestatus,
      "totalduration": totalduration,
      "slotcount": slotcount,
      "slots": selectedData,
      "orderid": orderid,

      "total": total,
      "discount": disount,
      "tax": tax,
      "finaltotal": finaltotal,
      "paymentstatus": paymentstatus,
      "time": "time",
      "date": "date",
      "activation": "true",
      "lat": lat,
      "log": log,
      "address": address,
      "serviceplace" : serviceplace,
      "servicetype": servicetype
    });
  }

  Future<void> afterPaymentToMyOrder() async{
    return await FirebaseFirestore
        .instance.collection("users")
        .doc(userid)
        .collection("myorder")
        .doc(orderid)
        .update({
      "servicestatus" : servicestatus,
      "paymentstatus" : paymentstatus
    });
  }

  Future<void> afterPaymentToMyOrderReschedule() async{

    Map<String,Map<String,String>> selectedData = Map();

    data.forEach((key, value)
    {
      selectedData[key] = {
        "start": "${value.start}",
        "status": "${value.status}"
      };
    });

    return await FirebaseFirestore
        .instance.collection("users")
        .doc(userid)
        .collection("myorder")
        .doc(orderid)
        .update({
      "servicestatus" : servicestatus,
      "paymentstatus" : paymentstatus,

      "userid": userid,
      "vendorid": vendorid,
      "serviceid": serviceid,
      "seattype": seattype,
      "selecteddate": selecteddate,
      "seatnumber": seatnumber,
      "gender" : gender,
      "starttime": starttime,
      "endtime": endtime,
      "servicestatus": servicestatus,
      "totalduration": totalduration,
      "slotcount": slotcount,
      "slots": selectedData,
      "orderid": orderid,
    });
  }


  Future<void> setOtpToFirebase(String oid,String vendorid,String otp){
    return FirebaseFirestore.instance.collection("Orders")
      .doc(vendorid)
      .collection("order")
        .doc(oid).update({
      "otp": otp
    });
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> verifyOtp(String userid,String oid,String vendorid){
    return FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(oid).get();
  }

  Future<void> updateOrderStatus(String oid,String vendorid,String uid){
    return FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(oid).update({
      "servicestatus": "complete"
    });
  }

  Future<void> updateOrderStatusAfterDone(String oid,String vendorid,String uid){
    return FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .collection("myorder")
        .doc(oid).update({
      "servicestatus": "complete"
    });
  }



  Future<void> updateOrderStatusCancel(String oid,String vendorid,String uid,String cancelby){
    return FirebaseFirestore.instance.collection("Orders")
        .doc(vendorid)
        .collection("order")
        .doc(oid).update({
      "servicestatus": "cancel",
      "cancelby": cancelby
    });
  }

  Future<void> updateOrderStatusAfterDoneCancel(String oid,String vendorid,String uid,String cancelby){
    return FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .collection("myorder")
        .doc(oid).update({
      "servicestatus": "cancel",
      "cancelby": cancelby
    });
  }






  Future<void> postReview(String userid,String vendorid,String orderid,String comment,String rate)
  {
   return FirebaseFirestore.instance.collection("business")
        .doc(vendorid)
        .collection("review")
        .doc(orderid).set({
      'userid': userid,
      'vendorid': vendorid,
      'orderid': orderid,
      'serviceid': serviceid,
      'comment': comment,
      'rate': rate,
      'date': 'date',
      'time': 'time',
      'activation': 'true'
    });
  }
  
  
  Future<void> removeCart(String salonid)
  {
    return FirebaseFirestore.instance.collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(salonid)
        .delete();
  }


}