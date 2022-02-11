import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class PackageCreation
{
  Future<void> createNewPackage(String userid,String packageName,String packageDesc,List service,String price,String duration,String discountOn,String discount,String time,String date)
  {
    String pid = Uuid().v1().toString();

    return FirebaseFirestore.instance.collection("packages").doc(userid).collection("package").doc(pid).set({
      'userid': userid,
      'packageid': pid,
      'packagename': packageName,
      'packagedesc':packageDesc,
      'service': service,
      'price': price,
      'duration': duration,
      'discounton': discountOn,
      'discount': discount,
      'time': time,
      'date': date,
      'activation': 'true'
    });
  }

  Future<void> updateNewPackage(String userid,String packageName,String packageDesc,List service,String price,String duration,String discountOn,String discount,String time,String date,String packageid)
  {

    return FirebaseFirestore.instance.collection("packages").doc(userid).collection("package").doc(packageid).update({
      'userid': userid,
      'packageid': packageid,
      'packagename': packageName,
      'packagedesc':packageDesc,
      'service': service,
      'price': price,
      'duration': duration,
      'discounton': discountOn,
      'discount': discount,
      'time': time,
      'date': date,
      'activation': 'true'
    });
  }
}
